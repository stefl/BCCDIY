module AutoCompleteJquery      
  
  def self.included(base)
    base.extend(ClassMethods)
  end

  #
  # Example:
  #
  #   # Controller
  #   class BlogController < ApplicationController
  #     auto_complete_for :post, :title
  #   end
  #
  #   # View
  #   <%= text_field_with_auto_complete :post, title %>
  #
  # By default, auto_complete_for limits the results to 10 entries,
  # and sorts by the given field.
  # 
  # auto_complete_for takes a third parameter, an options hash to
  # the find method used to search for the records:
  #
  #   auto_complete_for :post, :title, :limit => 15, :order => 'created_at DESC'
  #
  # For help on defining text input fields with autocompletion, 
  # see ActionView::Helpers::JavaScriptHelper.
  #
  # For more on jQuery auto-complete, see the docs for the jQuery autocomplete 
  # plugin used in conjunction with this plugin:
  # * http://www.dyve.net/jquery/?autocomplete
  module ClassMethods
    def auto_complete_for(object, method, options = {})
      define_method("auto_complete_for_#{object}_#{method}") do
        object_constant = object.to_s.camelize.constantize
        find_options = { 
          :conditions => [ options[:extra_conditions] + " AND (LOWER(#{method}) LIKE ?)", '%' + params[:q].downcase + '%' ], 
          :order => "#{method} ASC",
          :select => "#{object_constant.table_name}.#{method}",
          :limit => 10 }
        
        options.delete(:extra_conditions)
        
        find_options.merge!(options)
        
        @items = object_constant.find(:all, find_options).collect(&method)

        response.headers['Cache-Control'] = 'public, max-age=3600'
        
        logger.info @items.to_xml
        #render :text => @items.join("\n"), :layout => false
      end
    end
  end
  
end
