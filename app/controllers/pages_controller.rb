

class PagesController < ResourceController::Base
  auto_complete_for :page, :title, :extra_conditions=> "pages.alias IS NOT true"
  before_filter :send_cache_headers, :only=>[:show]
  
  def go_to_title
    page = Page.find_by_title(params[:page][:title])
    
    if(page)
      redirect_to page_path(page)
    else
      pages = Page.find_by_sql(["select * from pages where alias = false and (LOWER(title) LIKE ?)", '%' + params[:page][:title].downcase + '%' ])
      
      unless pages.blank?
        page = pages[0]
        redirect_to page_path(page)
        
      else
        flash[:notice] = "Sorry - We couldn't find anything for #{params[:page][:title]}"
        
        redirect_to home_path
      
      end
    end  
    
  end
  
  def hide
    page = Page.find_by_id(params[:id])
    
    page.alias = true
    page.save
    redirect_to page_path(page.parent)
  end

  show.wants.xml {render :xml=>@page}
  show.wants.json {render :json=>@page}
  
  def send_cache_headers
    response.headers['Cache-Control'] = 'public, max-age=300'
  end
  
  private
    def object
      @object ||= end_of_association_chain.find_by_slug(param)
    end
  
end
