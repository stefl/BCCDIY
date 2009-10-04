if ENV['MEMCACHE_SERVERS']
  require 'memcache'
  servers = ENV['MEMCACHE_SERVERS'].split(',')
  namespace = ENV['MEMCACHE_NAMESPACE']
  CACHE = MemCache.new(servers, :namespace => namespace)
end
