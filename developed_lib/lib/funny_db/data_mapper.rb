module FunnyDb
  class DataMapper
    def initialize(group_name, initializer)
      @name = group_name.to_sym
      @staged_data = initializer.body.fetch(@name, [])
      @changed_data = copy_staged_data
      @father = initializer
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
