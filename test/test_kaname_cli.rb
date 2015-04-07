require 'minitest_helper'

class TestKanameCLI < Minitest::Test
  def setup
    Kaname::Resource.stubs(:users_hash).returns(YAML.load_file('test/fixtures/actual.yml'))
  end

  def test_create_user
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_001.yml'))

    Kaname::Adapter::Mock.any_instance.expects(:create_user).once
    Kaname::Adapter::Mock.any_instance.expects(:create_user_role).once

    Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
  end

  def test_create_user_twice_role
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_002.yml'))

    Kaname::Adapter::Mock.any_instance.expects(:create_user).once
    Kaname::Adapter::Mock.any_instance.expects(:create_user_role).twice

    Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
  end

  def test_modify_role
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_003.yml'))

    Kaname::Adapter::Mock.any_instance.expects(:create_user_role).once
    Kaname::Adapter::Mock.any_instance.expects(:delete_user_role).once
    Kaname::Adapter::Mock.any_instance.expects(:change_user_role).once

    Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
  end

  def test_delete_user
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_004.yml'))

    Kaname::Adapter::Mock.any_instance.expects(:create_user).once
    Kaname::Adapter::Mock.any_instance.expects(:create_user_role).once
    Kaname::Adapter::Mock.any_instance.expects(:delete_user).once

    Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
  end
end
