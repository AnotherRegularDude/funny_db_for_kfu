require 'test_helper'

class TestDataMapper < MiniTest::Test
  def setup
    @mi_holder = structurized_manager_instance_init

    @data_mapper = FunnyDb::DataMapper.new('maptests', @mi_holder.instance)
    @list_to_insert = [{ name: 'test1' }, { name: 'test2' }]
  end

  def test_insert_list_of_data
    last_index = @data_mapper.insert_list(@list_to_insert)

    assert_equal 1, last_index
  end

  def test_register_changes_method
    @data_mapper.insert_list(@list_to_insert)
    @data_mapper.register_all_changes

    assert_equal @list_to_insert, @mi_holder.body[:maptests]
  end

  def test_dropping_by_session
    @data_mapper.insert_list(@list_to_insert)
    @data_mapper.register_all_changes

    @data_mapper.drop_all_session_changes

    assert_empty @mi_holder.body[:maptests]
  end

  def teardown
    clear_tmp
  end
end
