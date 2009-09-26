class PageVersionsController < ResourceController::Base

  index.wants.rss {
      render_rss_feed_for(@page_versions, { :feed => {:title => "BCCDIY Recent edits", :link => page_versions_url},
                            :item => {:title => Proc.new {|page| page.title + " updated by " + page.user.login},
                                      :link =>  Proc.new {|page| page_path(page)},
                                       :description => Proc.new {|page|  page.page.is_textile ? RedCloth.new(page.content).to_html : page.content
                                         },                                       
                                       :pub_date => :updated_at}
      })
  }
  
  index.wants.xml{
   render :xml=>@page_versions 
  }
  
  index.wants.json{
   render :json=>@page_versions 
  }
  
  private
     def collection
       params[:page] = 1 if params[:page].blank?
       @collection ||= end_of_association_chain.paginate :page => params[:page], :order => 'id DESC'
       
     end
  
end