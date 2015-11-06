require 'minitest_helper'

class TestKanameAdapterReal < Minitest::Test
  def test_update_user_password
    mock_auth = MiniTest::Mock.new.expect(:token, 'dummy_token')
    mock_user = MiniTest::Mock.new.expect(:id, 'dummy_id')

    dummy_management_url = "http://www.example.com:5000/v2.0"

    stub_request(:patch, "#{dummy_management_url}/OS-KSCRUD/users/dummy_id").
      with(:body => "{\"user\":{\"password\":\"new\",\"original_password\":\"old\"}}",
           :headers => {'Content-Type'=>'application/json', 'X-Auth-Token'=>"dummy_token"}).
      to_return(:status => 200)

    Yao::Auth.stub(:try_new, mock_auth) do
      Yao::User.stub(:get_by_name, mock_user) do
        Kaname::Config.stub(:management_url, dummy_management_url) do
          Kaname::Adapter::Real.new.update_user_password('old', 'new')
        end
      end
    end

    mock_auth.verify
    mock_user.verify
  end
end
