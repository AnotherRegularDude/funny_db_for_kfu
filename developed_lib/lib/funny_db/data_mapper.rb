##
# This class realize CRUD operations on database's items
# C - #insert_one(data_to_insert) and #insert_list(array_of_data_to_insert),
# where data_to_insert is a hash with structure you want,
# and array_of_data_to_insert - is a just array of data_to_insert
# R - #[index], where index - number from 0 to (infinity and beyond)
# U - update_at(index), where index - number from 0 to (infinity and beyond)
# D - delete_at(index), where index - number from 0 to (infinity and beyond)
module FunnyDb
  class DataMapper
    def initialize(group_name, initializer)
      @name = group_name.to_sym
      @father = initializer
      @father_body = @father.instance_variable_get(:@body)

      @staged_data = @father_body.fetch(@name, [])
      @changed_data = copy_staged_data
    end

    def [](index)
      @changed_data[index]
    end

    def last_index
      @changed_data.length - 1
    end

    def insert_one(data_to_insert)
      unless data_to_insert.is_a? Hash
        raise DataMapperError, 'Inserted data must be a hash'
      end

      return 0 if data_to_insert == {}

      @changed_data.push(data_to_insert)

      last_index
    end

    def insert_list(array_of_data_to_insert)
      array_of_data_to_insert.each { |ins_data| insert_one(ins_data) }

      last_index
    end

    def update_at(index)
      yield @changed_data[index]

      unless @changed_data[index].is_a? Hash
        raise DataMapperError, 'Changed item must be a hash'
      end

      Marshal.load(Marshal.dump(@changed_data[index]))
    end

    def delete_at(index)
      @changed_data.delete_at index
    end

    def drop_all_session_changes
      @changed_data = copy_staged_data
      register_all_changes
    end

    def register_all_changes
      @father.send(:changed_data_callback, @name, @changed_data)
    end

    private

    def copy_staged_data
      Marshal.load(Marshal.dump(@staged_data))
    end
  end
end
