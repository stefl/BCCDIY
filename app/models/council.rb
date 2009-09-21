class Council < ActiveRecord::Base
  
  # calls OpenlyLocal and grabs the Ward IDs, creating local activerecord objects to save on HTTP traffic
  def self.reindex
    c = OpenlyLocal::Council.find(167)
    
    c.wards.each do |open_ward|
      puts open_ward.to_xml
      
      ward = OpenlyLocal::Ward.find(open_ward.id)
      puts ward.to_xml
      
      w = Ward.find_by_permalink(ward.name.parameterize)
      unless(w.blank?)
        w.openly_local_ward_id = open_ward.id
        w.save
      else
        puts "ERROR: ward missing from database: " + ward.name
      end
    end
  end
  
end