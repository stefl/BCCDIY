
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
        redirect_to constituency_ward_path(ward.constituency,ward)
        
      else
        flash[:notice] = "Sorry - We couldn't find anything for #{params[:ward][:name]}"
        redirect_to home_path
      end
    end  
    
  end
  
  
  show.wants.html { 
    
    source = "http://www.fixmystreet.com/rss/reports/Birmingham/" + @ward.name.gsub(' ', '+') # url or local file
    content = "" # raw content of rss feed will be loaded here
    open(source) do |s| content = s.read end
    rss = RSS::Parser.parse(content, false)

    @fix_my_street = rss.items unless rss.blank?
        
    @openly_local_ward = OpenlyLocal::Ward.find(@ward.openly_local_ward_id)        
    
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
