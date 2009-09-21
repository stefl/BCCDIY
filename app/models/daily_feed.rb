
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class DailyFeed < ActiveRecord::Base
  serialize :items
  def perform
    # ... do work to read and parse the feed and place it in the database
    
    source = url
    content = "" # raw content of rss feed will be loaded here
    open(source) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)
    unless rss.blank?  
      update_attribute(:items, rss.items)
    else
      return false
    end
  end
end
