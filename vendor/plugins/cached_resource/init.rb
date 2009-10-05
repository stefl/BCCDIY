
# check to see if cache_fu is loaded
puts "=> cached_resource requires cache_fu! >> git://github.com/defunkt/cache_fu.git" unless Object.const_defined?(:ActsAsCached)

if defined?(ActiveResource)
  ActiveResource::Base.send :include, CachedResource
end