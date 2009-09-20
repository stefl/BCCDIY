class ConstituenciesController < ResourceController::Base
  
  
  private
    def object
      debugger
      @object ||= end_of_association_chain.find_by_permalink(param)
    end
end
