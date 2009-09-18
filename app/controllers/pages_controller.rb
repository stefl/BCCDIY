class PagesController < ResourceController::Base
  def go_to_title
    page = Page.find_by_title(params[:page][:title])
    
    if(page)
      redirect_to page_path(page)
    else
      redirect_to home_path
    end  
    
  end
  
  def hide
    page = Page.find_by_id(params[:id])
    
    page.alias = true
    page.save
    redirect_to page_path(page.parent)
  end
end
