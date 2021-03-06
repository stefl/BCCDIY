class CommitteesController < ResourceController::Base
  index.wants.xml{
    @council = OpenlyLocal::Council.find(167)
    render :xml=>@council.committees
    }
    
  index.wants.html{
    @council = OpenlyLocal::Council.find(167)
    
    @committees = @council.committees
  }
  
  index.wants.json{
    @council = OpenlyLocal::Council.find(167)
    render :json=>@council.committees
  }
  show.wants.json{render :json=>@committee.to_json}
  
  
  show.wants.xml{render :xml=>@committee.to_xml}
  private
    def object
      @object ||= OpenlyLocal::Committee.find(param) #end_of_association_chain.find_by_id(param)
    end
end
