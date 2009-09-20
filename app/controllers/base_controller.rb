class BaseController < ApplicationController
  auto_complete_for :page, :title, :extra_conditions=> "pages.alias IS NOT true"
  auto_complete_for :ward, :name, :extra_conditions=> "wards.name IS NOT NULL"
  # Standard functions not giving enough control - overriding.

  
  def home
    @page_title = "Birmingham City Council - DIY Community Version"
  
  end
end
