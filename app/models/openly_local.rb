
module OpenlyLocal
  
  class Member < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "member"
    cached_resource :ttl => 7.days
    
  end

  class Ward < ActiveResource::Base
      self.site = "http://openlylocal.com/"
      self.element_name = "ward"
      cached_resource :ttl => 7.days
      def local_ward
        Ward.find_by_openly_local_ward_id(self.id) unless self.id.blank?
      end
  end
  
  class Council < ActiveResource::Base
      self.site = "http://openlylocal.com/"
      self.element_name = "council"
      cached_resource :ttl => 7.days
  end
  
  class Council::Dataset < ActiveResource::Base
    
  end
  

  class Meeting < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "meeting"
    cached_resource :ttl => 7.days
  end

  class Member::ForthcomingMeeting < Meeting
    
  end

  class Committee < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "committee"
    cached_resource :ttl => 7.days
    def ward
      begin
        Ward.find_by_openly_local_ward_id(self.ward_id) unless self.ward_id.blank?
      rescue
      end
    end
    
  end
  
  
  class Meeting < ActiveResource::Base
    self.site = "http://openlylocal.com/"
    self.element_name = "meeting"
    cached_resource :ttl => 7.days
    
  end

  

end