class Ward < ActiveRecord::Base
  belongs_to :constituency
  
  has_permalink :name
  
  def to_param
     self.permalink
   end
end
