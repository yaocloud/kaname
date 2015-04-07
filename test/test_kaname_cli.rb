require 'minitest_helper'

class TestKanameCLI < Minitest::Test
  def test_create_user
    Kaname::Resource.stubs(:users_hash).returns(YAML.load_file('test/fixtures/actual.yml'))
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_001.yml'))

    Kaname::Adapter::Mock.any_instance.expects(:create_user).once
    Kaname::Adapter::Mock.any_instance.expects(:create_user_role).once

    Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
  end
end
