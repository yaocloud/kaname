require 'minitest_helper'

class TestKanameCLI < Minitest::Test
  def setup
    @dummy_users_hash = YAML.load_file('test/fixtures/actual.yml')
    @dummy_user = {"id" => "dummy_id", "name" => "dummy_name"}

    Kaname::Config.stubs(:setup)
  end

  def test_create_user
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_001.yml'))

    Kaname::Adapter::ReadOnly.any_instance.expects(:create_user).once
    Kaname::Adapter::ReadOnly.any_instance.expects(:create_user_role).once

    Kaname::Adapter::ReadOnly.stub_any_instance(:users_hash, @dummy_users_hash) do
      Kaname::Adapter::ReadOnly.stub_any_instance(:find_user, @dummy_user) do
        Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
      end
    end
  end

  def test_create_user_twice_role
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_002.yml'))

    Kaname::Adapter::ReadOnly.any_instance.expects(:create_user).once
    Kaname::Adapter::ReadOnly.any_instance.expects(:create_user_role).twice

    Kaname::Adapter::ReadOnly.stub_any_instance(:users_hash, @dummy_users_hash) do
      Kaname::Adapter::ReadOnly.stub_any_instance(:find_user, @dummy_user) do
        Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
      end
    end
  end

  def test_modify_role
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_003.yml'))

    Kaname::Adapter::ReadOnly.any_instance.expects(:create_user_role).once
    Kaname::Adapter::ReadOnly.any_instance.expects(:delete_user_role).once
    Kaname::Adapter::ReadOnly.any_instance.expects(:change_user_role).once

    Kaname::Adapter::ReadOnly.stub_any_instance(:users_hash, @dummy_users_hash) do
      Kaname::Adapter::ReadOnly.stub_any_instance(:find_user, @dummy_user) do
        Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
      end
    end
  end

  def test_delete_user
    Kaname::Resource.stubs(:yaml).returns(YAML.load_file('test/fixtures/expected_004.yml'))

    Kaname::Adapter::ReadOnly.any_instance.expects(:create_user).once
    Kaname::Adapter::ReadOnly.any_instance.expects(:create_user_role).once
    Kaname::Adapter::ReadOnly.any_instance.expects(:delete_user).once

    Kaname::Adapter::ReadOnly.stub_any_instance(:users_hash, @dummy_users_hash) do
      Kaname::CLI.new.invoke(:apply, [], {dryrun: true})
    end
  end
end
