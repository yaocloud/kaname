require 'minitest_helper'

class TestKanameResource < Minitest::Test
  def setup
    Kaname::Config.stubs(:setup)
    @list_tenants = [Yao::Resources::Tenant.new({'name' => 'tenant_a'})]
  end

  def test_yaml
    Kaname::Adapter::ReadOnly.stub_any_instance(:list_tenants, @list_tenants) do
      Dir.chdir "test/fixtures" do
        resource = Kaname::Resource.yaml('actual.yml')
        assert_equal Hash, resource.class
        assert_equal 'member', resource['foo']['tenants']['tenant_a']
        assert_equal 'admin', resource['foo']['tenants']['buzz']
        assert_nil resource['foo']['all_tenants']
      end
    end
  end

  def test_yaml_with_no_file
    refute Kaname::Resource.yaml
  end
end
