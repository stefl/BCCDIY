
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'
require 'anemone'
require 'nokogiri'

class ScrapeJob < ActiveRecord::Base
  def perform
    logger.info("perform srapejob")
    # ... do work to read and parse the feed and place it in the database
    case self.model
      
      when "Job"
        job_page = Nokogiri::HTML(open(url))
        job_page.css('th[scope=row] a').each do |link|
          url = "http://birmingham.gov.uk" + link['href']
           unless Job.exists?(:url => url )
             logger.info("Scraping: " + url)
             Delayed::Job.enqueue Job.create(:url=>url)
           end
        end
    end
  end
  
  def self.jobs_scrape
    
    unless ScrapeJob.exists?(["created_at > ? AND model = 'Jobs'", Date.yesterday])
    
      Delayed::Job.enqueue ScrapeJob.create(:model=>"Job", :url=>"http://birmingham.gov.uk/cs/Satellite?c=Page&childpagename=SystemAdmin%2FPageLayout&cid=1186475475913&packedargs=post_SortBy%3DDisplayTitle%26post_method%3DPOST%26post_pagination%3D1%26post_searchPageId%3D1223115858902%26website%3D1&pagename=BCC%2FCommon%2FWrapper%2FWrapper&rendermode=live")
      Delayed::Job.enqueue ScrapeJob.create(:model=>"Job", :url=>"http://birmingham.gov.uk/cs/Satellite?c=Page&childpagename=SystemAdmin%2FPageLayout&cid=1186475475913&packedargs=post_SortBy%3DDisplayTitle%26post_method%3DPOST%26post_pagination%3D2%26post_searchPageId%3D1223115858902%26website%3D1&pagename=BCC%2FCommon%2FWrapper%2FWrapper&rendermode=live")
      Delayed::Job.enqueue ScrapeJob.create(:model=>"Job", :url=>"http://birmingham.gov.uk/cs/Satellite?c=Page&childpagename=SystemAdmin%2FPageLayout&cid=1186475475913&packedargs=post_SortBy%3DDisplayTitle%26post_method%3DPOST%26post_pagination%3D2%26post_searchPageId%3D1223115858902%26website%3D1&pagename=BCC%2FCommon%2FWrapper%2FWrapper&rendermode=live")
      Delayed::Job.enqueue ScrapeJob.create(:model=>"Job", :url=>"http://birmingham.gov.uk/cs/Satellite?c=Page&childpagename=SystemAdmin%2FPageLayout&cid=1186475475913&packedargs=post_SortBy%3DDisplayTitle%26post_method%3DPOST%26post_pagination%3D3%26post_searchPageId%3D1223115858902%26website%3D1&pagename=BCC%2FCommon%2FWrapper%2FWrapper&rendermode=live")
    end
  end
end