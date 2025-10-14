# frozen_string_literal: true

module FunnyDb
  # Provides CRUD operations on a subset of FunnyDb records.
  #
  # @example Insert, update, and persist records
  #   manager = FunnyDb::Manager.new("/tmp/test_db")
  #   mapper = FunnyDb::DataMapper.new(:users, manager)
  #   mapper.insert_one(name: "Ivan")
  #   mapper.update_at(0) { |record| record[:name] = "Ilya" }
  #   mapper.register_all_changes
  class DataMapper
    # @param group_name [String, Symbol] target collection name
    # @param initializer [FunnyDb::Manager] manager instance responsible for persistence
    def initialize(group_name, initializer)
      @name = group_name.to_sym
      @father = initializer
      @father_body = @father.instance_variable_get(:@body)

      @staged_data = @father_body.fetch(@name, [])
      @changed_data = copy_staged_data
    end

    # @param index [Integer]
    # @return [Hash,nil] cloned data mapped at the given index
    def [](index)
      @changed_data[index]
    end

    # @return [Integer] the highest valid index for the current dataset
    def last_index
      @changed_data.length - 1
    end

    # Inserts one record into the mapper.
    #
    # @param data_to_insert [Hash] record to insert
    # @raise [DataMapperError] when record is not a hash
    # @return [Integer] index of the last element after insertion
    def insert_one(data_to_insert)
      raise DataMapperError, "Inserted data must be a hash" unless data_to_insert.is_a?(Hash)

      return 0 if data_to_insert == {}

      @changed_data.push(Marshal.load(Marshal.dump(data_to_insert)))

      last_index
    end

    # Inserts a list of records sequentially.
    #
    # @param array_of_data_to_insert [Array<Hash>] records to insert
    # @return [Integer] index of the last inserted record
    def insert_list(array_of_data_to_insert)
      array_of_data_to_insert.each { |ins_data| insert_one(ins_data) }

      last_index
    end

    # Updates a record at the given index using the provided block.
    #
    # @param index [Integer]
    # @yieldparam [Hash] record
    # @raise [DataMapperError] if updated record is not a hash
    # @return [Hash] deep copy of the updated record
    def update_at(index)
      yield @changed_data[index]

      raise DataMapperError, "Changed item must be a hash" unless @changed_data[index].is_a?(Hash)

      Marshal.load(Marshal.dump(@changed_data[index]))
    end

    # Removes a record at the given index.
    #
    # @param index [Integer]
    # @return [Hash,nil] removed record
    def delete_at(index)
      @changed_data.delete_at index
    end

    # Drops staged changes and re-registers original data.
    #
    # @return [void]
    def drop_all_session_changes
      @changed_data = copy_staged_data
      register_all_changes
    end

    # Persists staged changes into the backing manager.
    #
    # @return [void]
    def register_all_changes
      @father.send(:changed_data_callback, @name, @changed_data)
    end

    private

    # @return [Array<Hash>] deep clone of the staged data set
    def copy_staged_data
      Marshal.load(Marshal.dump(@staged_data))
    end
  end
end
