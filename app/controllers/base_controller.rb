class BaseController < ApplicationController
  auto_complete_for :page, :title, :extra_conditions=> "pages.alias IS NOT true"
  
  def home
    @page_title = "BCC DIY"
  
  end
end
