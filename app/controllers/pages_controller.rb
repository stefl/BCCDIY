

class PagesController < ResourceController::Base
  auto_complete_for :page, :title, :extra_conditions=> "pages.alias IS NOT true"
  
  #before_filter :redirect_to_alias, :only=>[:show]
  
  before_filter :send_cache_headers, :only=>[:show]
  
  
     def parse_textile
  
       render :text => RedCloth.new(params[:data]).to_html
  
     end

  
  
  def go_to_title
    unless params[:page].blank?
      unless params[:page][:title].blank?
        page = Page.find_by_title(params[:page][:title])
    
        if(page)
          redirect_to page_path(page)
        else
          #pages = Page.find_by_sql(["select * from pages where alias = false and (LOWER(title) LIKE ?)", '%' + params[:page][:title].downcase + '%' ])
          pages = Page.find_by_solr(params[:page][:title])
          unless pages.blank?
            #page = pages[0]
            #redirect_to pages_path(page)
        
            @pages = pages.docs
            render "pages/search"
          else
            flash[:notice] = "Sorry - We couldn't find anything for #{params[:page][:title]}"
        
            redirect_to home_path
      
          end
        end  
      end
    end
  end
  
  def hide
    page = Page.find_by_id(params[:id])
    
    page.alias = true
    page.save
    redirect_to page_path(page.parent)
  end
  
  def move
    page = Page.find_by_id(params[:id])
  end

  show.wants.html { 
    redirect_to_alias
    render
  } 
  show.wants.xml {render :xml=>@page}
  show.wants.json {render :json=>@page}
  
  def send_cache_headers
    #response.headers['Cache-Control'] = 'public, max-age=3600'
  end
  
  def redirect_to_alias

    #if @object.alias
      #redirect_to page_path(Page.find(@object.alias_id))
    #end
  end
  
  private
    def object
      @object ||= end_of_association_chain.find_by_slug(param)
    end
  
end
