class MeetingsController < ResourceController::Base
  index.wants.xml{
    @council = OpenlyLocal::Council.find(167)
    render :xml=>@council.meetings
    }
    
  index.wants.html{
    @council = OpenlyLocal::Council.find(167)
    
    @meetings = @council.meetings
  }
  
  index.wants.json{
    @council = OpenlyLocal::Council.find(167)
    render :json=>@council.meetings
  }
  show.wants.json{render :json=>@meeting.to_json}
  
  show.wants.xml{render :xml=>@meeting.to_xml}
  private
    def object
      @object ||= OpenlyLocal::Meeting.find(param) #end_of_association_chain.find_by_id(param)
    end
    
end
