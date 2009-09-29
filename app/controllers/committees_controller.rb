class CommitteesController < ResourceController::Base
  index.wants.xml{
    @council = OpenlyLocal::CouncilRemote.find(167)
    render :xml=>@council.committees
    }
    
  index.wants.html{
    @council = OpenlyLocal::CouncilRemote.find(167)
    
    @committees = @council.committees
  }
  show.wants.xml{render :xml=>@committee.to_xml}
  private
    def object
      @object ||= OpenlyLocal::CommitteeRemote.find(param) #end_of_association_chain.find_by_id(param)
    end
end
