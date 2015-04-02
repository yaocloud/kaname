require 'minitest_helper'

class TestKaname < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kaname::VERSION
  end

  def test_yaml
    Dir.chdir "test/fixtures" do
      assert_equal Hash, Kaname::Resource.yaml.class
    end
  end

  def test_yaml_with_no_file
    assert_equal "", Kaname::Resource.yaml
  end
end
