
module OpenlyLocal
  
  class MemberRemote < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "member"
  end

  class WardRemote < ActiveResource::Base
      self.site = "http://openlylocal.com/"
      self.element_name = "ward"
      
    
  end

  class CouncilRemote < ActiveResource::Base
      self.site = "http://openlylocal.com/"
      self.element_name = "council"
      
  end

  class CommitteeRemote < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "committee"

    def ward
      begin
        Ward.find_by_openly_local_ward_id(self.ward_id) unless self.ward_id.blank?
      rescue
      end
    end
    
  end
  
  class MeetingRemote < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "meeting"

    
  end

end