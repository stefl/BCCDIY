task :cron => :environment do

  puts "Updating event feed"
  Delayed::Job.enqueue DailyFeed.create(:url=>"http://allbrum.co.uk/today.rss")
  puts "Updating flickr feed"
  flickr_url = "http://www.degraeve.com/flickr-rss/rss.php?tags=bccdiypick&tagmode=all&sort=date-posted-desc&num=25"
  Delayed::Job.enqueue DailyFeed.create(:url=>flickr_url)
  puts "Updating news"
  Delayed::Job.enqueue DailyFeed.create(:url=>"http://birminghamnewsroom.com/?feed=rss2")
  
  puts "Scraping jobs"
  ScrapeJob.jobs_scrape
  puts "Updating planning applications..."
  Delayed::Job.enqueue ScrapeJob.create(:model=>"Planning")
  
  puts "done."
end