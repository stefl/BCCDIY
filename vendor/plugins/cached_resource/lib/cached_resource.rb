module CachedResource

  def self.included(receiver)
    receiver.extend(ClassMethods)
  end

  module ClassMethods

    def cached_resource(options = {})

      acts_as_cached(options)

      class << self

        def find_with_cache(*arguments)
          scope = arguments[0]
          case scope
          when :all   then cached_find_every(arguments)
          when :first then cached_find_one(arguments)
          when :one   then cached_find_one(arguments)
          else             cached_find_single(arguments)
          end
        end

        def cached_find_every(arguments)
          path_as_key = path_key(arguments)
          response_elements = nil
          cached_id_array = get_cache(path_as_key) do
            response_elements = find_without_cache(*arguments)
            response_elements.collect do |cached_element|
              # can only sub cache elements if they have an id
              if cached_element.attributes.has_key? "id"
                set_cache(cached_element.id, cached_element, self.cache_config[:ttl]) 
                cached_element.id
              else
                cached_element
              end
            end  
          end

          response_elements || cached_id_array.map { |key| key.is_a?(String) || key.is_a?(Integer) ? cached_find_single([key]) : key }
        end

        def cached_find_one(arguments)
          path_as_key = path_key(arguments)
          get_cache(path_as_key) do
            self.find_without_cache(*arguments)
          end
        end

        def cached_find_single(arguments)
          scope = arguments[0]
          get_cache(scope) do
            self.find_without_cache(*arguments)
          end
        end

        alias_method_chain :find, :cache

        private

        def path_key(arguments)
          scope   = arguments[0]
          options = arguments[1] || {}

          return "#{scope}:" +
            case from = options[:from]
            when Symbol
              custom_method_collection_url(from, options[:params])
            when String
              "#{from}#{query_string(options[:params])}"
            else
              prefix_options, query_options = split_options(options[:params])
              collection_path(prefix_options, query_options)
            end          
        end

      end
    end
  end
end
