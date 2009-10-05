class ToolsController < ResourceController::Base
  show.wants.xml {render :xml=>@tool}
  show.wants.json {render :json=>@tool}
  index.wants.xml {render :xml=>@tools}
  index.wants.json {render :json=>@tools}
end
