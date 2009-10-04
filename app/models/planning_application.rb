require 'nokogiri'
require 'open-uri'
require 'mechanize'
require 'net/http'



class PlanningApplication < ActiveRecord::Base
  def perform
    # ... do work to read and parse the feed and place it in the database
    
    results = self.search_all
    
    unless results.blank?
      self.create_from_list results
    end
  end

  USERAGENT = 'Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.0.1) Gecko/20060111 Firefox/1.5.0.1'
  PANEL = 'eplanning.birmingham.gov.uk'
  PATH = '/Northgate/PlanningExplorer/GeneralSearch.aspx'
  def self.search_all
    

       http = Net::HTTP.new(PANEL, 80)
       http.read_timeout = 120
       resp, data = http.get2(PATH, {'User-Agent' => USERAGENT})
       cookie = resp.response['set-cookie'].split('; ')[0]
       
       
       page = Nokogiri::HTML(data)

       viewstate = page.css('input').first[:value]
              
       @headers = {
             'Cookie' => cookie,
             'Referer' => 'http://'+PANEL+PATH,
             'Content-Type' => 'application/x-www-form-urlencoded',
             'User-Agent' => USERAGENT
           }

       
       data = '__VIEWSTATE=' + ERB::Util.url_encode(viewstate) + '&cboApplicationTypeCode=&cboDays=1&cboDevelopmentTypeCode=&cboMonths=1&cboSelectDateValue=DATE_RECEIVED&cboStatusCode=&cboWardCode=&csbtnSearch=Search&dateEnd=&dateStart=&edrDateSelection=&rbGroup=rbMonth&search-term=&txtAgentName=&txtApplicantName=&txtApplicationNumber=&txtProposal=&txtSiteAddress='
       
       
       resp, data = http.post2(PATH, data, @headers)
       
       if resp.class == Net::HTTPFound
       
         xml_url = data.match(/XMLLoc=(.*)?'/)
       
         page = Nokogiri::XML(open("http://"+PANEL + xml_url[1]))
         return page
       else
        return nil
      end

  end
  
  def self.create_from_list results
    
    
    results.css("M3_DC_LIVE_GENERAL_QUERY_LIST").each do |item|
      
      council_reference = item.css("APPLICATION_NUMBER")[0].content

      if PlanningApplication.find_by_council_reference(council_reference).blank?
        address = item.css("SITE_ADDRESS")[0].content
        postcode = address.split("\n").reverse[0]
        id = item.css("PK")[0].content
        app = PlanningApplication.new(
        :description => item.css("PROPOSAL")[0].content,
        :council_reference=> council_reference,
        :council_id=> id,
        :date_received=> item.css("DATE_RECEIVED")[0].content,
        :address=> address,
        :postcode=> postcode,
        :info_url=> "http://eplanning.birmingham.gov.uk/Northgate/PlanningExplorer/Generic/StdDetails.aspx?PT=Planning%20Applications%20On-Line&TYPE=PL/PlanningPK.xml&PARAM0=#{id}&XSLT=/Northgate/PlanningExplorer/SiteFiles/Skins/Birmingham/xslt/PL/PLDetails.xslt&FT=Planning%20Application%20Details&PUBLIC=Y&XMLSIDE=/Northgate/PlanningExplorer/SiteFiles/Skins/Birmingham/Menus/PL.xml&DAURI=PLANNING",
      
        :comment_url=>"http://eplanning.birmingham.gov.uk/Northgate/PlanningExplorer/PLComments.aspx?pk=#{id}"
      
        )
      
        app.save
        
        pp app
      end
    end
  end
  
  def self.last_month
    page = Nokogiri::HTML(open('http://eplanning.birmingham.gov.uk/Northgate/PlanningExplorer/GeneralSearch.aspx'))
    
    agent = WWW::Mechanize.new
    agent.redirect_ok = true
    Hpricot.buffer_size = 1048576
    page = agent.get('http://eplanning.birmingham.gov.uk/Northgate/PlanningExplorer/GeneralSearch.aspx')
    
    #pp page #pretty print the page
    
    
    form = page.form("M3Form")
    
    form.radiobuttons_with(:name => 'rbGroup')[0].check
    
    form.buttons_with(:name=>'csbtnSearch')[0].value = 'Search'
    #pp form # pretty print the form
    
    results = agent.submit(form)
    
    puts "RESULTS"

    
    pp results.header
    
    results
    
    
    #viewstate = page.css('input').first[:value]
    #post('http://eplanning.birmingham.gov.uk/Northgate/PlanningExplorer/GeneralSearch.aspx', :query=>{"_VIEWSTATE"=>viewstate, "cboDays"=>1, "cboMonths"=>1, "cboSelectDateValue"=>"DATE_RECEIVED","csbtnSearch"=>"Search","rbGroup"=>"rbMonth","cboApplicationTypeCode"=>'',"cboDevelopmentTypeCode"=>'',	"cboStatusCode" => '', #:cboWardCodeEDN
#"dateEnd" => '',
#"dateStar" => '',
#"edrDateSelection"	=> '',
#"search-term" =>'',	
#"txtAgentName" => '',	
#"txtApplicantName" => '',	
#"txtApplicationNumber" => '',
#"txtProposal" => '',
#"txtSiteAddress" => ''  })
  end
end
