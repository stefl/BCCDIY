require 'open-uri'
require 'anemone'
require 'nokogiri'

class Job < ActiveRecord::Base
  
  def format_description
    self.description = self.description.gsub(/<table(.*)?<\/table>/m, '').gsub(/<h2(.*)?<\/h2>/m,'').gsub(/<table(.*)?<\/table>/m, '').gsub(/<h2(.*)?<\/h2>/m,'').gsub('href="/', 'href="http://www.birmingham.gov.uk/') 
  end
  
  def perform
    job_page = Nokogiri::HTML(open(self.url))
    
    self.title = job_page.css('.vacancy h2').inner_html.strip
    self.description = job_page.css('.vacancy').inner_html
    self.format_description
    job_page.css('.vacancytable tr').each do |row|
      row_title = row.css('th').inner_html.to_s.strip
      row_value = row.css('td').inner_html.to_s.strip
      case row_title
        when "Directorate:"
          self.directorate = row_value
        when "Service Area:"
          self.service_area = row_value
        when "Job Reference Number:"
          self.reference = row_value
        when "Contract Type:"
          self.contract_type = row_value
        when "Closing Date:"
          self.closing_date = Date.parse(row_value)
        when "Criminal Records Bureau:"
          self.cbi_check = true if row_value.match("Yes")[0]
        when "Criminal Records Bureau Text:"
          self.cbi_check_text = row_value
        when "Salary:"
          self.salary = row_value
        when "Salary range:"

          self.salary_low = row_value[/\d+/]
          
          self.salary_high = row_value.sub(/\d+/, '')[/\d+/]
      end
    end

    self.save
    logger.info self.to_xml
    
  end
end
