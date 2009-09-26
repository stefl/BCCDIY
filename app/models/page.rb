require 'anemone'
require 'nokogiri'
#require 'tidy'
require 'html2textile'


class Page < ActiveRecord::Base
  acts_as_solr :fields=>["title","content"]
  acts_as_tree :order => "title"
  acts_as_versioned
  belongs_to :user
  #acts_as_paranoid
  
  
  self.non_versioned_columns << 'url' << 'page_source' << 'breadcrumb' << 'parent_url' << 'created_at' << 'favorite'
  #default_scope :conditions => 'pages.alias = false'

  named_scope :aliased, :conditions => 'pages.alias = true'
  named_scope :unaliased, :conditions => 'pages.alias = false'
  named_scope :recently_updated, :limit => 10, :order=>'updated_at desc'
  #instance methods  
  #before_save :set_slug
  
  #TODO sort out the aliasing properly has_one :alias_page, :class_name => "Page", :source=> :page
  
  has_permalink :title, :slug
  
  # for helpers
  def name
    title
  end 
  
  def to_param
    self.slug
  end
  
  def original_content
    self.versions[0].content
  end
  
  def original_content_as_textile
    
    
    parser = HTMLToTextileParser.new
    parser.feed(self.versions[0].content)
    parser.to_textile
  end
  
  # Remove any unnecessary text from titles
  def retitle
    self.title = self.title.sub(' - Birmingham City Council', '')
    save
  end
  
  # find a Page object based on a plain url
  def self.get_alias_from_link_or_slug alias_url, slug_text
    sql = "select * from pages where pages.url like '%" + alias_url + "%' limit 1"
    logger.info sql
    possibles = Page.find_by_sql(sql)
    possible = possibles[0]
    logger.info 'found ' + possible.to_s
    if possible.blank?
      sql = "select * from pages where pages.slug like '%" + slug_text + "%' limit 1"
      possibles = Page.find_by_sql(sql)
      possible = possibles[0]
      logger.info 'found ' + possible.to_s
    end
    unless possible.blank?
      if possible.alias
        possible_alias = Page.find_by_id(possible.alias_id)
        possible = possible_alias unless possible_alias.blank?
      end
    end
    logger.info 'Success: ' + possible.title.to_s unless possible.blank?
    possible
  end
  
  # returns the content, cleaned and ready for display
  def parsed_content
    #content
    #TODO turn this off! set the following to false
    content = self.relink_content false
    #content = Page.cleanup(content) #unless it's already been done locally that is...
      
  end
  
  def parsed_content_as_textile 
    
    parser = HTMLToTextileParser.new
    parser.feed(self.relink_content false)
    parser.to_textile
    
  end
  
  # Set this Page as an alias to another Page by passing it's ID
  def alias_to(the_alias_id)
    self.alias = true
    self.alias_id = the_alias_id
    self.save
  end
  
  
  # Clean up the two content areas of the object
  def clean
    self.content = self.parsed_content

    self.page_source = Page.cleanup(self.page_source)
        
    self.save
  end
  
  
  # extracts all the link urls from the page content and returns as an array
  def extract_links
    unless self.content.blank?
      links = []
      results = self.content.scan(/href="(.*?)"/)
      results.each do |result|
        logger.info "Extract result: " + result[0]
        links << result[0].to_s
      end
      links.flatten
      
    end    
  end

  
  # relink any local links in the content
  
  def relink_content crawl
    the_content = self.content
    unless the_content.blank?
      links = self.extract_links
      logger.info links
      relinks = {}
      
      if links.size > 0
        links.delete_if {|x| x.match(/^http:\/\//) }
        links.delete_if {|x| x.match(/^mailto:/) }
        links.delete_if {|x| x.match(/^javascript:/) }
        
        links.each do |link|
          link = link.sub('/','')
          logger.info "link: " + link
          extracted_cid = Page.extract_cid(link) 
          link_url = link
          link_url = extracted_cid unless extracted_cid.blank?
          page = Page.get_alias_from_link_or_slug(link_url,link)
          
          if crawl
            if page.blank?
              url="http://birmingham.gov.uk/#{link}".gsub('&amp;','&')
              page = Page.create_from_anemone_page Anemone::Page.fetch(url)
            else
              logger.info "page: " + page.id.to_s + " : " +  page.title.to_s
            end
          
          end
          unless page.blank?
          
            relinks['/' + link] = "/pages/" + page.slug 
          
          else
            
            relinks['/' + link] = "http://birmingham.gov.uk/" + link
          end
          
          
        end
        logger.info relinks.to_s
        relinks.each_key do |link_key|
          logger.info 'relink from: ' + link_key
          logger.info 'relink to: ' + relinks[link_key]
          the_content.gsub!(link_key.to_s, relinks[link_key].to_s)
        end
        
      end
      logger.info the_content
      the_content
    end
    #self.content
  end
  
  
  #class methods
  
  # We get a bunch of links in a #breadcrumb object, let's use that to work out the structure of the site
  def set_parent_page_from_last_breadcrumb_item
    #logger.info breadcrumb
    bread = Nokogiri::HTML(breadcrumb)
    the_link = nil
    bread.search('a').each do |link|
       logger.info link.content
       logger.info link['href']
       the_link = 'http://birmingham.gov.uk' + link['href']
    end
    logger.info 'Result of link finding: ' + the_link.to_s
    unless the_link.blank?
      possible_parent = Page.find_by_url(the_link)
      if possible_parent
        logger.info 'Found parent by url: ' + possible_parent.title
        
        self.parent_id = possible_parent.id
        self.save
        logger.info 'Saved new parent id'
      else
        logger.info 'No page found by url: ' + the_link
        
        new_page = Page.create_from_anemone_page Anemone::Page.fetch(the_link)
        if new_page
          self.parent_id = new_page.id
          self.save
        end
        
        
      end
    end
    
  end
  
  # work out a nice slug for urls based on either what we've been given already, or generate one from the page title
  def set_slug
    #some urls are helpfully slugged for us
    the_url =  self.url
    the_slug = ''
    
    unless the_url.include?('cs/Satellite/')
      # if we have a slug already in the url, let's use that
      the_slug = the_url.sub('http://birmingham.gov.uk/', '')
      
    else
      # otherwise, let's use the title 
      the_slug = self.title.parameterize
    end
    
    the_slug = the_slug.to_s.sub('-birmingham-city-council', '')
    
    self.slug = the_slug.to_s
    self.save
  end
  
  # Work out the main home page
  def self.root_page
    Page.find_by_slug('home')
  end
  
  # Create a new page by sending this function an instance of an Anemone::Page object
  def self.create_from_anemone_page page
    logger.info 'Create from anemone page'
    #begin
      unless page.blank? || page.doc.blank?  
        html = page.doc.at('html')
        unless html.blank?
          found_page = Page.find_by_url(page.url.to_s)
          unless found_page.blank?
            logger.info('Already indexed. Ignoring: ' + page.url.to_s)
          else
            
            title = page.doc.at('title')
            if title.blank?
              logger.info('Blank title. Ignoring: ' + page.url.to_s)
            else
        
              if(title.inner_html.include?('404') || title.inner_html.downcase.include?('error') || title.inner_html.downcase.include?('temporarily unavailable') )
                logger.info('404 found. Ignoring: ' + page.url.to_s)
              else
                p = Page.new()

        
        
                p.title = title.inner_html unless title.blank?

                p.url= page.url.to_s
        
                p.page_source= html.inner_html 
      
                breadcrumb = page.doc.css('#breadcrumb')
                unless breadcrumb.blank?
                  p.breadcrumb = breadcrumb.first.inner_html
                end
        
                page_content = page.doc.css('#content')
                unless page_content.blank?
                  p.content = page_content.first.inner_html
                end
                if p.save
                  logger.info('Saved: ' + p.title + ' : ' + p.url.to_s)
                  return p
                else
                  logger.info("Save failed: " + p.url.to_s)
                  
                end
                
              end # unless title 404
            end # unless title blank
          end # unless page already in database
        end # unless html blank
      end # unless page/doc blank
    #rescue
    #  logger.info('An error occurred. Continuing... ')
    #end #begin/rescue
    return false
  end

  
  # Cleans a string, removing various unnecessary content
  def self.cleanup content
    unless content.blank?
      content = content.gsub(/<h1>(.*?)<\/h1>/m, '') #lose titles
      content = content.gsub(/<img(.*?)>/, '') #lose images
      content = content.gsub(/<!--(.*?)-->/, '') #lose images
      content = content.gsub(/<p>(.*?)This page (.*?) as(.*?)<\/p>/m, '') #lose 'referred to as'
      content = content.gsub('<hr>', ' ') #remove extra spaces
      #content = content.gsub(/<div(.*?)>([\t\n\r ]*?)<\/div>/m, '') # lose empty divs
      content = content.gsub(/<[^\/>]*>([\s]?)*<\/[^>]*>/m,'') #lose empty tags
      content = content.gsub(/([\t\n\r]*)/m, '') #lose all the tabs
      content = content.gsub('<br>', '<br />') #lose all the tabs
      content = content.gsub('  ', ' ') #remove extra spaces
      #content = content.gsub(/<br>(.*?)<\/p>/m, '</p>') #lose poor formatting
      #content = content.gsub(/<br>(.*?)<\/li>/m, '</li>') #lose poor formatting
    end
  end

  
  # Utility to cut out a string of text based on a start and end pattern
  def self.cut_text(buffer,start_pattern, end_pattern)
    start_pos = buffer =~ /#{start_pattern}/
    remaining = $'
    end_pos = remaining =~ /#{end_pattern}/
    buffer.slice!(start_pos..buffer.length - remaining.length + end_pos + end_pattern.length - 2)
  end
  


  # Crawling utility methods
  # This is possibly lazy putting it in the model. This is a quick and dirty import.
  

  # Crawl the website with Anemone
  def self.crawl_bcc(start_url)
    start_url = "http://birmingham.gov.uk" if start_url.blank?
    counter = 0
    Anemone.crawl(start_url) do |anemone|
      
      anemone.focus_crawl do |page| 
        page.links.delete_if { |x| x.to_s[/c=Page&childpagename=SystemAdmin/] }
        page.links.delete_if { |x| x.to_s[/pagename=BCC%252FCommon%252FWrapper%252FWrapper/] }
        page.links.delete_if { |x| x.to_s[/Common%252FWrapper%252FInlineWrapper/] }
        page.links.delete_if { |x| x.to_s[/MungoBlob/] }
        #page.links.delete_if { |x| !Page.find_by_url(x.to_s).blank? }
      end  
      
      anemone.on_every_page do |page|
        counter = counter + 1 if Page.create_from_anemone_page page
      end #on_every_page
    end # do Anemone
    logger.info(counter.to_s + ' pages saved')
  end #self.crawl
  
  
  # On each page, work out what it's parent page is
  def self.setup_hierarchy # you may need to run this several times manually - sorry.
    pages = Page.find(:all)
    pages.each do |p|
      p.set_parent_page_from_last_breadcrumb_item
    end
  end
  
  # Clean up the HTML for every page in the database - strip whitespace, comments, etc.
  def self.clean_all
    pages = Page.find(:all)
    
    pages.each do |page|
      page.clean
    end
  end
  
  # Remove additional text from page titles
  def self.retitle_all
    pages = Page.find(:all)
    
    pages.each do |page|
      page.retitle
      page.set_slug
    end
  end
  
  # Remove all duplicate pages by setting the 'alias' flag. We will redirect visits to these pages, but keep the url
  # in the database so that we know this url refers to the same logical page.
  def self.remove_duplicates
    pages = Page.find(:all)
    
    pages.each do |page|
      unless page.alias
        #don't realias if it's already been set 
        duplicates = Page.find(:all, :conditions=>['title = ? AND parent_id = ?', page.title, page.parent_id])
        logger.info 'found ' + duplicates.size.to_s+ ' duplicates for ' + page.title
        if duplicates.size > 1
        
          best = duplicates[0]
          duplicates.each do |dup|
            best = dup if dup.url.length < best.url.length
          end
          
          logger.info 'the best alternative by url shortness is: ' + best.title
        
          duplicates.each do |dup|
            dup.alias_to(best) unless dup == best
          end
      
        end
      end
    end
  end
  
  def self.extract_cid source_url
    the_result = nil
    the_cid = source_url.match(/cid=([0-9]*)?/)
    the_result = the_cid[1] unless the_cid.blank?
    if the_result.blank?
      the_cid = source_url.match(/cid_=([0-9]*)?/)
      the_result = the_cid[1] unless the_cid.blank?
    end
    the_result
  end
  
  # Runs each important sequence on the site
  # It calls Setup Hierarchy three times because the original site has multiple nested orphan pages.
  def self.import_the_site do_crawl
    
    Page.crawl_bcc "http://birmingham.gov.uk" if do_crawl
    Page.setup_hierarchy
    Page.setup_hierarchy
    Page.setup_hierarchy
    # Do it three times for voodoo
    
    Page.retitle_all
    
  end
  
  # Go through every page on the site and where there are inline links, replace them with (possibly) correct inline links
  def self.relink_all_content
    pages = Page.find(:all)
    
    pages.each do |page|
      page.relink_content true
    end
    
    pages.size
  end
  
  def self.parse_all_content
    pages = Page.find(:all, :conditions=>["is_textile = false"])
    
    pages.each do |page|
      puts page.id
      page.update_attributes({:content=>page.parsed_content_as_textile, :is_textile=>true})
    end
    
    pages.size
  end
  
  
end #class
