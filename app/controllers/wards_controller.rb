
require 'rss/1.0'
require 'rss/2.0'
require 'open-uri'


class WardsController < ResourceController::Base
  belongs_to :constituency
  
  def go
    ward = Ward.find_by_name(params[:ward][:name])
    
    if(ward)
      redirect_to constituency_ward_path(ward.constituency,ward)
    else
      
      # try to get it via a postcode lookup
      
      ward = Ward.get_by_postcode(params[:ward][:name])
        
      unless ward.blank?
        cookies[:postcode] = params[:ward][:name].gsub(' ', '')
        redirect_to constituency_ward_path(ward.constituency,ward)
        
      else
        flash[:notice] = "Sorry - We couldn't find anything for #{params[:ward][:name]}"
        redirect_to home_path
      end
    end  
    
  end
  
  def fix_my_street
    @ward = Ward.find_by_permalink(params[:id])
    source = "http://www.fixmystreet.com/rss/reports/Birmingham/" + @ward.name.gsub(' ', '+') # url or local file
    feed = DailyFeed.find_by_url(source, :conditions=>["created_at > ?", Date.yesterday])
    unless feed.items.blank?
      render :update do |page|
        page.replace_html 'recent_problems', "<ul>" + render(:partial=>'shared/rss_item', :collection=>feed.items) + "</ul>"
        page.visual_effect :highlight, 'recent_problems'
        page << 'stop_loading_fix_my_street();'
        
      end
    end
  end
  
  def planning_alerts
    @ward = Ward.find_by_permalink(params[:id])
    source = "http://www.planningalerts.com/api.php?postcode=#{cookies[:postcode]}&area_size=m"
    feed = DailyFeed.find_by_url(source, :conditions=>["created_at > ?", Date.yesterday])
    unless feed.items.blank?
      render :update do |page|
        page.replace_html 'recent_alerts', "<ul>" + render(:partial=>'shared/rss_item', :collection=>feed.items) + "</ul>"
        page.visual_effect :highlight, 'recent_alerts'
        page << 'stop_loading_planning_alerts();'
      end
    end
  end
  
  
  show.wants.html { 
    
    source = "http://www.fixmystreet.com/rss/reports/Birmingham/" + @ward.name.gsub(' ', '+') # url or local file
        
    @openly_local_ward = OpenlyLocal::Ward.find(@ward.openly_local_ward_id)        
    
        
    fix_my_street_feed = DailyFeed.find_by_url(source, :conditions=>["created_at > ?", Date.yesterday])
    if fix_my_street_feed.blank?
      Delayed::Job.enqueue DailyFeed.create(:url=>source)
      @fix_my_street = ''
    else
      @fix_my_street = fix_my_street_feed.items
    end
        
    
    unless cookies[:postcode].blank?
      
      source = "http://www.planningalerts.com/api.php?postcode=#{cookies[:postcode]}&area_size=m"
      
      planning_alerts_feed = DailyFeed.find_by_url(source, :conditions=>["created_at > ?", Date.yesterday])
      if planning_alerts_feed.blank?
        Delayed::Job.enqueue DailyFeed.create(:url=>source)
        @planning_alerts = ''
      else
        @planning_alerts = planning_alerts_feed.items
      end

    end
    render
    }
    
  show.wants.xml { render :xml=>@ward}
  show.wants.json { render :json=>@ward}
  index.wants.xml { render :xml=>@wards}
  index.wants.json { render :json=>@wards}
  
  
  private
    def object
      @object ||= end_of_association_chain.find_by_permalink(param)
    end
    
    def parent_object
      @parent_object ||= Constituency.find_by_permalink(params[:constituency_id])
    end
end
