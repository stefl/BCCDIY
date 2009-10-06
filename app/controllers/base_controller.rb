
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'

class BaseController < ApplicationController
  auto_complete_for :page, :title, :extra_conditions=> "pages.alias IS NOT true"
  auto_complete_for :ward, :name, :extra_conditions=> "wards.name IS NOT NULL"
  # Standard functions not giving enough control - overriding.
  skip_before_filter :verify_authenticity_token
  def broken_link
    #response.headers['Cache-Control'] = 'public, max-age=300' unless logged_in?
    #flash[:notice] = "Sorry - Looks like that's a broken link"
    @original_url = request.url.to_s.gsub("bccdiy.com","birmingham.gov.uk")
    
  end
  
  def contact
    @page_title = "Contacting the Council"
    respond_to do |wants|
      wants.html{ render }
      wants.xml{render :xml=>"Any ideas?".to_xml}
      wants.json{render :json=>"Any ideas?".to_json}
    end
  end
  def news
    @page_title = "News"
    @rss_title = "Birmingham City Council News"
    @rss_url = "http://bccdiy.com/news.rss"
    news_feed = DailyFeed.find_by_url("http://birminghamnewsroom.com/?feed=rss2", :order=>"created_at desc", :limit=>1)
    @news = news_feed.items

    respond_to do |wants|
      wants.html{ render } 
      wants.json{ render :json=>@news.to_json } 
      
      wants.xml do 
        
         render_rss_feed_for(@news, { :feed => {:title => @rss_title, :link => news_url},
                                :item => {:title => Proc.new {|item| item.title},
                                          :link =>  Proc.new {|item| item.link},
                                           :description => Proc.new {|item| item.description},                                       
                                           :pub_date => Proc.new {|item| item.date}
          }})
      end
      wants.rss do 
        # TODO - this isn't very DRY!
         render_rss_feed_for(@news, { :feed => {:title => @rss_title, :link => news_url},
                                :item => {:title => Proc.new {|item| item.title},
                                          :link =>  Proc.new {|item| item.link},
                                           :description => Proc.new {|item| item.description},                                       
                                           :pub_date => Proc.new {|item| item.date}
          }})
      end
    end
  end
  
  def events
    @page_title = "Events"
    @rss_title = "Birmingham City Council Events"
    @rss_url = "http://bccdiy.com/events.rss"
    events_feed = DailyFeed.find_by_url("http://allbrum.co.uk/today.rss", :order=>"created_at desc", :limit=>1)
    @events = events_feed.items

    respond_to do |wants|
      wants.html{ render } 
      wants.json{ render :json=>@events.to_json } 
      wants.xml do 
        
         render_rss_feed_for(@events, { :feed => {:title => @rss_title, :link => events_url},
                                :item => {:title => Proc.new {|item| item.title},
                                          :link =>  Proc.new {|item| item.link},
                                           :description => Proc.new {|item| item.description},                                       
                                           :pub_date => Proc.new {|item| item.date}
          }})
      end
      wants.rss do 
         # TODO - this isn't very DRY!
         render_rss_feed_for(@events, { :feed => {:title => @rss_title, :link => events_url},
                                :item => {:title => Proc.new {|item| item.title},
                                          :link =>  Proc.new {|item| item.link},
                                           :description => Proc.new {|item| item.description},                                       
                                           :pub_date => Proc.new {|item| item.date}
          }})
      end
    end
  end
  
  def home
    
    #@edit_count = PageVersion.count(:all)
    #response.headers['Cache-Control'] = 'public, max-age=300' unless logged_in?
    @tools = Tool.find(:all, :order=>"title asc")
    @page_title = "Birmingham City Council - DIY Community Version"
    @featured_pages = Page.find(:all, :conditions=>"pages.favorite = true", :order=>"pages.title asc")
    
    #ScrapeJob.jobs_scrape

    unless params[:expire].blank?
      expire_fragment('home_page')
    end
    
    events_feed = DailyFeed.find_by_url("http://allbrum.co.uk/today.rss", :conditions=>["created_at > ?", Date.yesterday])
    if events_feed.blank?
      Delayed::Job.enqueue DailyFeed.create(:url=>"http://allbrum.co.uk/today.rss")
      @events_today = ''
    else
      @events_today = events_feed.items
    end
    
    begin
      @featured_events = ScrapeJob.scrape_featured_events[0]
    rescue
    end
    
    flickr_url = "http://www.degraeve.com/flickr-rss/rss.php?tags=bccdiypick&tagmode=all&sort=date-posted-desc&num=25"
    flickr_feed = DailyFeed.find_by_url(flickr_url, :conditions=>["created_at > ?", Date.yesterday])
    if flickr_feed.blank?
      Delayed::Job.enqueue DailyFeed.create(:url=>flickr_url)
      @flickr_today = ''
    else
      @flickr_today = flickr_feed.items
    end
    
    #TODO this means once per day at about midnight someone won't see an events feed
    @recently_updated_pages = PageVersion.find(:all, :limit=>10, :order=>"id desc")
    
    news_feed = DailyFeed.find_by_url("http://birminghamnewsroom.com/?feed=rss2", :conditions=>["created_at > ?", Date.yesterday])
    if news_feed.blank?
      Delayed::Job.enqueue DailyFeed.create(:url=>"http://birminghamnewsroom.com/?feed=rss2")
      @news_today = ''
    else
      @news_today = news_feed.items
    end
    
  end
  
end
