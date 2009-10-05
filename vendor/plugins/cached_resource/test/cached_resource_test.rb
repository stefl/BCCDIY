require File.join(File.dirname(__FILE__), 'helper')

class CachedResourceTest < Test::Unit::TestCase

  def test_load
    assert TestClass.respond_to?(:cached_resource, "should respond to cached_resource")
    assert TestClass.respond_to?(:find_with_cache, "should respond to find_with_cache")
    assert TestClass.respond_to?(:find_without_cache, "should respond to find_without_cache")
  end

end
