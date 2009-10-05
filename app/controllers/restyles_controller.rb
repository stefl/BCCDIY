class RestylesController < ResourceController::Base
  def apply
    @restyle = Restyle.find(params[:id])
    cookies[:restyle_id] = @restyle.id
    redirect_to restyle_path(@restyle)
  end
  
  def revert
    cookies[:restyle_id] = nil
    redirect_to restyles_path
  end
  
  show.wants.xml {render :xml=>@restyle}
  show.wants.json {render :json=>@restyle}
  index.wants.xml {render :xml=>@restyles}
  index.wants.json {render :json=>@restyles}
end
