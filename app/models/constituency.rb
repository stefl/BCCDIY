class Constituency < ActiveRecord::Base
  has_many :wards
  has_permalink :name
  acts_as_solr :fields=>["name"]
  def to_param
     self.permalink
   end
end
