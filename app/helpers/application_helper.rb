# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def page_title
    @page_title
  end
  
  def body_styles
    
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
end
