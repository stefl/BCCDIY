class ConstituenciesController < ResourceController::Base
  
  caches_action :index
  
  index.wants.html { @wards = Ward.find(:all, :order=>"name asc") 
    render
    }
  show.wants.xml { render :xml=>@constituency}
  show.wants.json { render :json=>@constituency}
  index.wants.xml { render :xml=>@constituencies}
  index.wants.json { render :json=>@constituencies}
  
  
  private
    def object
      @object ||= end_of_association_chain.find_by_permalink(param)
    end
end
