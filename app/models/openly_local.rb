
module OpenlyLocal
  
  class Member < ActiveResource::Base
    self.site = "http://openlylocal.com/"
  
  end

  class Ward < ActiveResource::Base
      self.site = "http://openlylocal.com/"
  end

  class Council < ActiveResource::Base
      self.site = "http://openlylocal.com/"
  end

  class Committee < ActiveResource::Base
    self.site = "http://openlylocal.com/"

  end

end