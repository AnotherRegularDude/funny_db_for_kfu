# frozen_string_literal: true

require 'spec_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe FunnyDb::DataMapper do
  let(:data_mapper_setup) { structurized_data_mapper('maptests') }
  let(:data_mapper) { data_mapper_setup.mapper }
  let(:mi_holder) { data_mapper_setup.holder }
  let(:list_to_insert) do
    [
      { name: 'test1', foo: 'bar' },
      { name: 'test2', foo: 'bar' }
    ]
  end

  describe '#insert_list' do
    it 'returns the last inserted index' do
      expect(data_mapper.insert_list(list_to_insert)).to eq(1)
    end
  end

  describe '#register_all_changes' do
    it 'persists the staged changes into the manager body' do
      data_mapper.insert_list(list_to_insert)
      data_mapper.register_all_changes

      expect(mi_holder.body[:maptests]).to eq(list_to_insert)
    end
  end

  describe '#drop_all_session_changes' do
    it 'clears staged changes' do
      data_mapper.insert_list(list_to_insert)
      data_mapper.register_all_changes
      data_mapper.drop_all_session_changes

      expect(mi_holder.body[:maptests]).to be_empty
    end
  end

  describe '#update_at' do
    it 'updates an item and persists the change' do
      data_mapper.insert_list(list_to_insert)
      data_mapper.register_all_changes

      data_mapper.update_at(0) { |el| el[:name] = 'changed' }
      data_mapper.register_all_changes

      list_to_insert[0][:name] = 'changed'

      expect(mi_holder.body[:maptests]).to eq(list_to_insert)
    end
  end

  describe '#delete_at' do
    it 'removes an item from the collection' do
      data_mapper.insert_list(list_to_insert)
      data_mapper.register_all_changes

      data_mapper.delete_at(0)
      data_mapper.register_all_changes

      expect(data_mapper.last_index).to eq(0)
    end
  end
end
# rubocop:enable Metrics/BlockLength
