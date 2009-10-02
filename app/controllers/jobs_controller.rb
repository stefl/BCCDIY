class JobsController < ResourceController::Base
  private
     def collection
       params[:page] = 1 if params[:page].blank?
       @collection ||= end_of_association_chain.paginate :page => params[:page], :order => 'closing_date DESC'
       
     end
end
