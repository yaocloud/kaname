require 'minitest_helper'

class TestKanameAdapterReal < Minitest::Test
  def test_update_user_password
    credentials = {:openstack_current_user_id => "foo", :openstack_auth_token => "bar", :openstack_management_url => "http://www.example.com/v2.0"}

    stub_request(:patch, "http://www.example.com:5000/v2.0/OS-KSCRUD/users/foo").
      with(:body => "{\"user\":{\"password\":\"new\",\"original_password\":\"old\"}}",
           :headers => {'Content-Type'=>'application/json', 'X-Auth-Token'=>"bar"}).
      to_return(:status => 200)

    Kaname::Adapter::Real.new.update_user_password(credentials, "old", "new")
  end
end
