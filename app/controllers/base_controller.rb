
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class BaseController < ApplicationController
  auto_complete_for :page, :title, :extra_conditions=> "pages.alias IS NOT true"
  auto_complete_for :ward, :name, :extra_conditions=> "wards.name IS NOT NULL"
  # Standard functions not giving enough control - overriding.

  
  def home
    response.headers['Cache-Control'] = 'public, max-age=300'
    
    @page_title = "Birmingham City Council - DIY Community Version"
    
    source = "http://allbrum.co.uk/today.rss"
    content = "" # raw content of rss feed will be loaded here
    open(source) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)

    @events_today = rss.items unless rss.blank?
    
    source = "http://birminghamnewsroom.com/?feed=rss2"
    content = "" # raw content of rss feed will be loaded here
    open(source) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)

    @news_today = rss.items unless rss.blank?
  end
  
end
