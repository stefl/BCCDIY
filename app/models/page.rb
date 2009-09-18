require 'anemone'
require 'nokogiri'
#require 'tidy'



class Page < ActiveRecord::Base
  
  acts_as_tree :order => "title"


  def set_parent_page_from_last_breadcrumb_item
    #puts breadcrumb
    bread = Nokogiri::HTML(breadcrumb)
    the_link = nil
    bread.search('a').each do |link|
       puts link.content
       puts link['href']
       the_link = 'http://birmingham.gov.uk' + link['href']
    end
    puts 'Result of link finding: ' + the_link.to_s
    unless the_link.blank?
      possible_parent = Page.find_by_url(the_link)
      if possible_parent
        puts 'Found parent by url: ' + possible_parent.title
        
        self.parent_id = possible_parent.id
        self.save
        puts 'Saved new parent id'
      else
        puts 'No page found by url: ' + the_link
        
        new_page = Page.create_from_anemone_page Anemone::Page.fetch(the_link)
        if new_page
          self.parent_id = new_page.id
          self.save
        end
        
        
      end
    end
    
  end
  
  def self.root_page
    Page.find_by_url('http://birmingham.gov.uk/')
  end
  
  def self.setup_hierarchy # you may need to run this several times manually - sorry.
    pages = Page.find(:all)
    pages.each do |p|
      p.set_parent_page_from_last_breadcrumb_item
    end
  end
  
  def self.create_from_anemone_page page
    puts 'Create from anemone page'
    #begin
      unless page.blank? || page.doc.blank?  
        html = page.doc.at('html')
        unless html.blank?
          found_page = Page.find_by_url(page.url.to_s)
          unless found_page.blank?
            puts('Already indexed. Ignoring: ' + page.url.to_s)
          else
        
            title = page.doc.at('title')
            if title.blank?
              puts('Blank title. Ignoring: ' + page.url.to_s)
            else
        
              if(title.inner_html.include?('404') || title.inner_html.downcase.include?('error') )
                puts('404 found. Ignoring: ' + page.url.to_s)
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
                  puts('Saved: ' + p.title + ' : ' + p.url.to_s)
                  return p
                else
                  puts("Save failed: " + p.url.to_s)
                  
                end
                
              end # unless title 404
            end # unless title blank
          end # unless page already in database
        end # unless html blank
      end # unless page/doc blank
    #rescue
    #  puts('An error occurred. Continuing... ')
    #end #begin/rescue
    return false
  end
  
  def retitle
    self.title = self.title.sub(' - Birmingham City Council', '')
    save
  end
  
  def parsed_content
    
    content = Page.cleanup(self.content)

    
  end
  
  def self.cleanup content
    unless content.blank?
      content = content.gsub(/<h1>(.*?)<\/h1>/m, '') #lose titles
      content = content.gsub(/<img(.*?)>/, '') #lose images
      content = content.gsub(/<!--(.*?)-->/, '') #lose images
      content = content.gsub(/<p><strong>This page may be referred to as(.*?)<\/p>/m, '') #lose 'referred to as'
      content = content.gsub(/([\t\n\r]*)/m, '') #lose all the tabs
      content = content.gsub('  ', ' ') #remove extra spaces
      #content = content.gsub(/<br>(.*?)<\/p>/m, '</p>') #lose poor formatting
      #content = content.gsub(/<br>(.*?)<\/li>/m, '</li>') #lose poor formatting
    end
  end
  
  def clean
    self.content = self.parsed_content

    self.page_source = Page.cleanup(self.page_source)
        
    self.save
  end
  
  def self.cut_text(buffer,start_pattern, end_pattern)
    start_pos = buffer =~ /#{start_pattern}/
    remaining = $'
    end_pos = remaining =~ /#{end_pattern}/
    buffer.slice!(start_pos..buffer.length - remaining.length + end_pos + end_pattern.length - 2)
  end
  
  
  def self.retitle_all
    pages = Page.find(:all)
    
    pages.each do |page|
      page.retitle
    end
  end
  
  def self.remove_duplicates
    pages = Page.find(:all)
    
    pages.each do |page|
      duplicates = Page.find(:all, :conditions=>['title = ?', page.title])
      
      if duplicates.size > 1
        
        best = duplicates[0]
        duplicates.each do |dup|
          best = dup if dup.url.length < best.url.length
        end
        
        duplicates.each do |dup|
          dup.alias_to(best) unless dup == best
        end
        
        
        
      end
      
    end
  end
  

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
    puts(counter.to_s + ' pages saved')
  end #self.crawl
  
  def alias_to(the_alias_id)
    self.alias = true
    self.alias_id = the_alias_id
    self.save
  end
  
  def self.clean_all
    pages = Page.find(:all)
    
    pages.each do |page|
      page.clean
    end
  end
  
  def self.import_the_site do_crawl
    
    Page.crawl_bcc "htt://birmingham.gov.uk" if do_crawl
    Page.setup_hierarchy
    Page.setup_hierarchy
    Page.setup_hierarchy
    # Do it three times for voodoo
    
    Page.retitle_all
    
    
  end
  
  
end #class
