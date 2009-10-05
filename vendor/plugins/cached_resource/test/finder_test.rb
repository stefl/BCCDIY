require File.join(File.dirname(__FILE__), 'helper')

class FinderTest < Test::Unit::TestCase
  
  # ActiveResource::Base::find will invoke a find_every(options).first
  # When caching, we assume a single object returns instead of a collection
  def test_find_first_caches_single_object
    TestClass.expects(:cached_find_every).with([:first]).never
    TestClass.expects(:cached_find_one).with([:first]).once
    assert_nothing_raised {TestClass.find(:first)}
  end
  
  # When a cache hit occurs, validate that a collection of integers
  # get looked up as well when the id isn't necessarily a string
  def test_find_all_returns_collection_of_objects_and_not_keys
    TestClass.stubs(:get_cache).with(TestClass.send(:path_key, [:all])).returns([909])
    TestClass.expects(:cached_find_single).once
    assert_nothing_raised {TestClass.find(:all)}
  end
  
  # When invoking find with :first or :all, the path key isn't unique.
  # Validate uniqueness so both arguments are cached separately.
  # We'll prepend the scope in case the collection path is the same
  def test_for_uniqueness_when_retrieving_path_key
    first_path_key = TestClass.send(:path_key, [:first])
    all_path_key = TestClass.send(:path_key, [:all])
    assert_not_equal first_path_key, all_path_key
    assert_equal "first:/test_classes.xml", first_path_key
    assert_equal "all:/test_classes.xml", all_path_key
  end
  
  # Validate the path_key when the :from argument has a symbol
  # We expect it to return the correct collection path
  def test_from_argument_when_its_a_symbol
    first_path_key = TestClass.send(:path_key, [:first, {:from => :listings}])
    assert_equal "first:/test_classes/listings.xml", first_path_key
    one_path_key = TestClass.send(:path_key, [:one, {:from => :listings}])
    assert_equal "one:/test_classes/listings.xml", one_path_key
  end
  
end
