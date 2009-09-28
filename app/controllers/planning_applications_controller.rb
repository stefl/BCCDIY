class PlanningApplicationsController < ResourceController::Base
  index.wants.rss {
    render_rss_feed_for(@planning_applications, { :feed => {:title => "BCCDIY Planning Applications", :link => planning_applications_url},
                          :item => {:title => Proc.new {|app| app.address.split("\n")[0] + ", " + app.postcode},
                                    :link =>  Proc.new {|app| planning_application_url(app)},
                                     :description => Proc.new {|app|  app.description },                                       
                                     :pub_date => :date_received}
    }) 
  }
  
  index.wants.xml {
   render :xml => @planning_applications
  }
  
  def planning_alerts
    
    day = params[:day]
    month = params[:month]
    year = params[:year]
    date = Date.new(year.to_i,month.to_i,day.to_i)
    @planning_applications = PlanningApplication.find(:all, :conditions  => { :date_received  => date })
    builder = Nokogiri::XML::Builder.new do |xml|
       xml.planning {
         xml.authority_name "Birmingham City Council"
         xml.authority_short_name "Birmingham"
         xml.applications {
           @planning_applications.each do |o|
           
             xml.application {
               xml.council_reference o.council_reference
               xml.address o.address
               xml.postcode o.postcode
               xml.description o.description
               xml.info_url o.info_url
               xml.comment_url o.comment_url
               xml.date_received o.date_received.strftime("%d/%m/%Y")
             }
           end
         }
       }
     end
     render :xml=>builder.to_xml
  end
  
  index.wants.json {
   render :json => @planning_applications
  }
  
  show.wants.xml {
   render :xml => @planning_application 
  }
  
  show.wants.json {
   render :json => @planning_application 
  }
  
  
end
