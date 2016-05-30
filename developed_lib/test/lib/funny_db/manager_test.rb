require 'test_helper'
require 'digest'

class TestManager < MiniTest::Test
  def setup
    @manager_instance = FunnyDb::Manager.new(db_path)
    @buffered_default_structure = default_structure
  end

  def db_path(db_name = 'test_db', for_constructor = true)
    final_db_name = if for_constructor
                      db_name
                    else
                      db_name + '.db.json'
                    end

    File.join(TEST_TMP, final_db_name)
  end

  def default_head
    {
      hash: '',
      table_count: 0,
      locked: false,
      table_typings: [
      ]
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
    result[:head][:hash] = Digest::SHA256.base64digest result.to_s

    result
  end

  def test_initialize_instance_correctly
    another_instance = FunnyDb::Manager.new(db_path('another_db'))

    assert_instance_of FunnyDb::Manager, another_instance
    assert_equal true, File.exist?(db_path('another_db', false))
  end

  def test_db_file_struct_corresponds_to_default_struct
    file_structure = Oj.load(
      File.open(db_path('test_db', false)).read,
      @manager_instance.oj_options
    )

    assert_equal @buffered_default_structure, file_structure
  end

  def teardown
    clear_tmp
  end
end
