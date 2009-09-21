class Constituency < ActiveRecord::Base
  has_many :wards
  has_permalink :name
  #acts_as_solr
  def to_param
     self.permalink
   end
end
