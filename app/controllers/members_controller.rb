class MembersController < ResourceController::Base
  index.wants.xml{
    @council = OpenlyLocal::CouncilRemote.find(167)
    render :xml=>@council.members
    }
    
  index.wants.html{
    @council = OpenlyLocal::CouncilRemote.find(167)
    
    @members = @council.members
  }
  
  show.wants.xml{render :xml=>@member.to_xml}
  private
    def object
      @object ||= OpenlyLocal::MemberRemote.find(param) #end_of_association_chain.find_by_id(param)
    end
    
end
