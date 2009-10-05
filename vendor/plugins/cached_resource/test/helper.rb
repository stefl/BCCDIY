ENV['RAILS_ENV'] = 'test'

require 'test/unit'
require 'rubygems'
require 'active_resource'
require 'active_resource/http_mock'
require 'mocha'

module ActsAsCached
  module Mixin
    def acts_as_cached(options = {})
      extend ClassMethods
    end
  end
  
  module ClassMethods
    def get_cache(*args)
      yield if block_given?
    end
    def set_cache(cache_id, value, ttl = nil)
      value
    end
  end
end

Object.send :include, ActsAsCached::Mixin

require 'cached_resource'
ActiveResource::Base.send :include, CachedResource

class TestClass < ActiveResource::Base
  self.site = "http://localhost"
  cached_resource
end
