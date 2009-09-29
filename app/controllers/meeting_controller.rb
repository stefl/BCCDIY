class MeetingController < ResourceController::Base
  
  show.wants.xml{render :xml=>@meeting.to_xml}
  private
    def object
      @object ||= OpenlyLocal::MeetingRemote.find(param) #end_of_association_chain.find_by_id(param)
    end
    
end
