
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class BaseController < ApplicationController
  auto_complete_for :page, :title, :extra_conditions=> "pages.alias IS NOT true"
  auto_complete_for :ward, :name, :extra_conditions=> "wards.name IS NOT NULL"
  # Standard functions not giving enough control - overriding.

  def broken_link
    flash[:notice] = "Sorry - Looks like that's a broken link"
    redirect_to home_path
  end
  
  def home
    response.headers['Cache-Control'] = 'public, max-age=300'
    
    @page_title = "Birmingham City Council - DIY Community Version"
    
    events_feed = DailyFeed.find_by_url("http://allbrum.co.uk/today.rss", :conditions=>["created_at > ?", Date.yesterday])
    if events_feed.blank?
      Delayed::Job.enqueue DailyFeed.create(:url=>"http://allbrum.co.uk/today.rss")
      @events_today = ''
    else
      @events_today = events_feed.items
    end
    
    #TODO this means once per day at about midnight someone won't see an events feed
    
    
    news_feed = DailyFeed.find_by_url("http://birminghamnewsroom.com/?feed=rss2", :conditions=>["created_at > ?", Date.yesterday])
    if news_feed.blank?
      Delayed::Job.enqueue DailyFeed.create(:url=>"http://birminghamnewsroom.com/?feed=rss2")
      @news_today = ''
    else
      @news_today = news_feed.items
    end
    
  end
  
end
