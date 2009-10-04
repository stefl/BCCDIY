require 'nokogiri'
require 'open-uri'

class Ward < ActiveRecord::Base
  acts_as_solr :fields=>["name"]
  belongs_to :constituency

  has_permalink :name

  has_many :members

  def to_param
     self.permalink
   end
   
  def openly_local_ward
    OpenlyLocal::WardRemote.find(self.openly_local_ward_id)
  end
 
  def self.get_by_postcode postcode
    
      lookup_url = "http://www.neighbourhood.statistics.gov.uk/dissemination/LeadAreaSearch.do?a=7&c=#{CGI::escape postcode }&d=14&r=0&i=1001&m=0&enc=1&areaSearchText=#{CGI::escape postcode}&areaSearchType=14&extendedList=false&searchAreas="

      result = ''
      doc = Nokogiri::HTML(open(lookup_url))

      logger.info doc

      title = doc.at('title').inner_html

      if title == "Check Browser Settings"
        follow_link = doc.css('a').first[:href]
        doc = Nokogiri::HTML(open(follow_link))
        logger.info doc        
      end
    
      result_title = doc.css('h1').first.inner_html
      result = nil
      results = result_title.match(/Area: (.*?) \(Ward\)/)
      unless results.blank?
        result = results[1]
      end
    
      unless result.blank?
        return Ward.find_by_permalink(result.parameterize)
      else
        return nil
      end
  end
end

