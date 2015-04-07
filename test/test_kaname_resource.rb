require 'minitest_helper'

class TestKanameResource < Minitest::Test
  def test_yaml
    Dir.chdir "test/fixtures" do
      assert_equal Hash, Kaname::Resource.yaml('actual.yml').class
    end
  end

  def test_yaml_with_no_file
    refute Kaname::Resource.yaml
  end
end
