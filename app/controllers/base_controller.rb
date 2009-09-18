class BaseController < ApplicationController
  auto_complete_for :page, :title
  
  def home
    @page_title = "BCC DIY"
  end
end
