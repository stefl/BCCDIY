class JobsController < ResourceController::Base
  
  index.wants.rss {
      render_rss_feed_for(@jobs, { :feed => {:title => "Jobs with Birmingham City Council", :link => jobs_url},
                            :item => {:title => :title,
                                      :link =>  Proc.new {|job| job_url(job)},
                                       :description => :description
                                         },                                       
                                       :pub_date => :updated_at
      })
  }
  
  index.wants.xml{
   render :xml=>@jobs
  }
  
  index.wants.json{
   render :json=>@jobs
  }
  
  show.wants.xml{
   render :xml=>@job
  }
  
  show.wants.json{
   render :json=>@job
  }
  
  private
     def collection
       params[:page] = 1 if params[:page].blank?
       @collection ||= end_of_association_chain.paginate :page => params[:page], :order => 'closing_date DESC', :conditions=>'title is not null'
       
     end
end
