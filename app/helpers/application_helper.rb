require 'md5'

# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    unless @page_title.blank?
      page_title = @page_title
    
      unless @is_home
        page_title = page_title + " | Birmingham City Council | BCC, UK on BCCDIY"
      
      else
        page_title = "Birmingham City Council DIY | A community-generated city council website | BCC, UK on BCCDIY "
      end
    else
      page_title = "Birmingham City Council DIY | A community-generated city council website | BCC, UK on BCCDIY "
    end
  end
  
  def body_styles
    
  end
  
  def avatar_for(user, size=32)
    image_tag "http://www.gravatar.com/avatar.php?gravatar_id=#{MD5.md5(user.email)}&rating=PG&size=#{size}", :size => "#{size}x#{size}", :class => 'photo'
  end
  
  # for tweets
  def linkup_mentions(text)
    text.gsub!(/@([\w]+)(\W)?/, '@<a href="http://twitter.com/\1">\1</a>\2')
    text
  end

  def pretty_datetime(datetime)
    date = datetime.strftime('%b %e, %Y').downcase
    time = datetime.strftime('%l:%M%p').downcase
    content_tag(:span, date, :class => 'date') + " " + content_tag(:span, time, :class => 'time')
  end
  
  
  
  def page_select selected
    html = ""
    root = Page.root_page
    
     # Add "Home" to the options
     html << "<select name=\"page[parent_id]\" id=\"page_parent_id\">\n"
     html << "\t<option value=\"#{root.id}\""
     html << " selected=\"selected\"" if selected == root.id
     html << ">Home</option>\n"
     
     pages = Page.find_by_sql("select id, parent_id, title from pages where parent_id is not null")
     children = []
     pages.each do |p|
       children << p if p.parent_id == root.id
     end
     children.reverse!
     
     html << page_select_options(pages, children, root.id, selected, level=0)
     
     html << "</select>\n"
     
     return html
  end

  def page_select_options(pages, children, id, selected=0, level=0)
    html = ""

    logger.info("Page select: " + id.to_s)
    #debugger

    if children.length > 0
      level += 1 # keep position
      children.collect do |page|
        html << "\t<option value=\"#{page.id}\" style=\"padding-left:#{level * 10}px\""
        html << ' selected="selected"' if page.id == id
        html << ">#{page.title}</option>\n"
        
        more_children = []
        pages.each do |p|
          more_children << p if p.parent_id == page.id
        end
        more_children.reverse!
        
        html << page_select_options(pages, more_children, page.id, selected, level)
      end
    end
    
    return html
  end
  
  def windowed_pagination_links(pagingEnum, options)
     link_to_current_page = options[:link_to_current_page]
     always_show_anchors = options[:always_show_anchors]
     padding = options[:window_size]

     current_page = pagingEnum.page
     html = ''

     #Calculate the window start and end pages 
     padding = padding < 0 ? 0 : padding
     first = pagingEnum.page_exists?(current_page  - padding) ? current_page - padding : 1
     last = pagingEnum.page_exists?(current_page + padding) ? current_page + padding : pagingEnum.last_page

     # Print start page if anchors are enabled
     html << yield(1) if always_show_anchors and not first == 1

     # Print window pages
     first.upto(last) do |page|
       (current_page == page && !link_to_current_page) ? html << page : html << yield(page)
     end

     # Print end page if anchors are enabled
     html << yield(pagingEnum.last_page) if always_show_anchors and not last == pagingEnum.last_page
     html
   end
  
  
end
