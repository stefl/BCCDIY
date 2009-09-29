class MeetingsController < ResourceController::Base
  index.wants.xml{
    @council = OpenlyLocal::CouncilRemote.find(167)
    render :xml=>@council.meetings
    }
    
  index.wants.html{
    @council = OpenlyLocal::CouncilRemote.find(167)
    
    @meetings = @council.meetings
  }
  
  index.wants.json{
    @council = OpenlyLocal::CouncilRemote.find(167)
    render :json=>@council.meetings
  }
  show.wants.json{render :json=>@meeting.to_json}
  
  show.wants.xml{render :xml=>@meeting.to_xml}
  private
    def object
      @object ||= OpenlyLocal::MeetingRemote.find(param) #end_of_association_chain.find_by_id(param)
    end
    
end
