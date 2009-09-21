class Member < ActiveRecord::Base
  belongs_to :ward
  #acts_as_solr
end