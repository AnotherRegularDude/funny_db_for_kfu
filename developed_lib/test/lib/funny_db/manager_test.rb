require 'test_helper'
require 'digest'

class TestManager < MiniTest::Test
  def setup
    @manager_instance = FunnyDb::Manager.new(db_path)
  end

  def default_head
    {
      hash: '',
      group_count: 0,
      locked: false
    }
  end

  def default_body
    {}
  end

  def default_structure
    result = {
      head: default_head,
      body: default_body
    }

    result[:head][:hash] = calc_hash(result)

    result
  end

  def struct_with_expected_group
    result = default_structure

    result[:head][:hash] = ''
    result[:body][:managertests] = [{ name: 'test1' }]

    result[:head][:hash] = calc_hash(result)

    result
  end

  def calc_hash(hashed_obj)
    Digest::SHA256.base64digest hashed_obj.to_s
  end

  def test_initialize_instance_correctly
    another_instance = FunnyDb::Manager.new(db_path('another_db'))

    assert_instance_of FunnyDb::Manager, another_instance
    assert_equal true, File.exist?(db_path('another_db', false))
  end

  def test_db_file_struct_corresponds_to_default_struct
    file_structure = Oj.load(
      File.open(db_path('test_db', false)).read,
      FunnyDb::Manager::OJ_OPTIONS
    )

    assert_equal default_structure, file_structure
  end

  def test_manager_return_data_mapper_on_index
    assert_instance_of FunnyDb::DataMapper, @manager_instance['selected_group']
  end

  def test_db_file_struct_corresponds_to_expected
    managertests = @manager_instance['managertests']

    managertests.insert_one(name: 'test1')
    managertests.register_all_changes

    @manager_instance.save_changes

    file_structure = Oj.load(
      File.open(db_path('test_db', false)).read,
      FunnyDb::Manager::OJ_OPTIONS
    )

    assert_equal struct_with_expected_group, file_structure
  end

  def teardown
    clear_tmp
  end
end
