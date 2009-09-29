
module OpenlyLocal
  
  class MemberRemote < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "member"
    
    def ward
      Ward.find_by_openly_local_ward_id(self.ward_id)
    end
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
      Ward.find_by_openly_local_ward_id(self.ward_id)
    end
    
  end
  
  class MeetingRemote < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "meeting"

    
  end

end