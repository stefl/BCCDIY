class PageVersionsController < ResourceController::Base
  index.wants.rss {
      render_rss_feed_for(@page_versions, { :feed => {:title => "BCCDIY Recent edits", :link => page_versions_url},
                            :item => {:title => Proc.new {|page| page.title + " updated by " + page.user.login},
                                      :link =>  Proc.new {|page| page_path(page)},
                                       :description => Proc.new {|page| @page.is_textile ? textilize(page.content) : page.content},                                       
                                       :pub_date => :created_at}
      })
  }
end