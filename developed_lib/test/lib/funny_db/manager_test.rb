require 'test_helper'

class TestManager < MiniTest::Test
  # Block of nontest methods: setup, teardown and other helpers
  # Setup and teardown block
  def setup
    @mi_holder = structurized_manager_instance_init
  end

  def teardown
    clear_tmp
  end

  # Declare default stuff block
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

  def default_data_to_insert
    { name: 'test1' }
  end

  def default_struct_with_expected_group
    result = default_structure

    result[:head][:hash] = ''
    result[:body][:managertests] = [default_data_to_insert]

    result[:head][:hash] = calc_hash(result)

    result
  end

  # Block of help methods
  def calc_hash(hashed_obj)
    Digest::SHA256.base64digest hashed_obj.to_s
  end

  def jsonify_db_file(db_name = 'test_db')
    Oj.load(
      File.open(db_path(db_name, false)).read,
      FunnyDb::Manager::OJ_OPTIONS
    )
  end

  # Here we start test methods
  def test_initialize_instance_correctly
    another_instance = FunnyDb::Manager.new(db_path('another_db'))

    assert_instance_of FunnyDb::Manager, another_instance
    assert_equal true, File.exist?(db_path('another_db', false))
  end

  def test_db_file_struct_corresponds_to_default_struct
    file_structure = jsonify_db_file

    assert_equal default_structure, file_structure
  end

  def test_manager_return_data_mapper_on_index
    checked_for = @mi_holder.instance['selected_group']

    assert_instance_of FunnyDb::DataMapper, checked_for
  end

  def test_db_file_struct_corresponds_to_expected
    managertests = @mi_holder.instance['managertests']

    managertests.insert_one(default_data_to_insert)
    managertests.register_all_changes
    @mi_holder.instance.save_changes

    file_structure = jsonify_db_file

    assert_equal default_struct_with_expected_group, file_structure
  end
end
