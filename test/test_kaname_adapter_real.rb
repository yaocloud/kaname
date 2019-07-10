require 'minitest_helper'

class TestKanameAdapterReal < Minitest::Test
  def test_update_user_password
    Kaname::Config.stubs(:setup)

    mock_user = MiniTest::Mock.new.expect(:id, 'dummy_id')

    dummy_management_url = "http://www.example.com:5000/v2.0"

    Yao::Client.reset_client(dummy_management_url)
    Yao.default_client.register_endpoints({"identity" => {public_url: dummy_management_url}})

    stub_request(:patch, "http://www.example.com:5000/v2.0/OS-KSCRUD/users/dummy_id").
      with(body: "{\"user\":{\"password\":\"new\",\"original_password\":\"old\"}}",
           headers: {'Accept'=>'application/json',
                     'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                     'Content-Type'=>'application/json',
                     'User-Agent'=>'Faraday v0.15.4'}).
    to_return(status: 200, body: "", headers: {})

    Yao::User.stub(:get_by_name, mock_user) do
      Kaname::Config.stub(:username, "dummy_username") do
        Kaname::Adapter::ReadAndWrite.new.update_user_password('old', 'new')
      end
    end

    mock_user.verify
  end
end
