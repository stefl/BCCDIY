class MembersController < ResourceController::Base
  index.wants.xml{
    @council = OpenlyLocal::Council.find(167)
    render :xml=>@council.members
    }
    
  index.wants.html{
    @council = OpenlyLocal::Council.find(167)
    
    @members = @council.members
  }
  
  
  index.wants.json{
    @council = OpenlyLocal::Council.find(167)
    render :json=>@council.members
  }
  show.wants.json{render :json=>@members.to_json}
  
  
  show.wants.xml{render :xml=>@member.to_xml}
  private
    def object
      @object ||= OpenlyLocal::Member.find(param) #end_of_association_chain.find_by_id(param)
    end
    
end
