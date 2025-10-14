# frozen_string_literal: true

require 'spec_helper'
require 'oj'

# rubocop:disable Metrics/BlockLength
RSpec.describe FunnyDb::Manager do
  let!(:mi_holder) { structurized_manager_instance_init }
  let(:manager) { mi_holder.instance }

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

  def calc_hash(hashed_obj)
    Digest::SHA256.base64digest(hashed_obj.to_s)
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

  def jsonify_db_file(db_name = 'test_db')
    Oj.load(
      File.read(db_path(db_name, for_constructor: false)),
      FunnyDb::Manager::OJ_OPTIONS
    )
  end

  describe '#initialize' do
    it 'creates a new database file' do
      another_instance = described_class.new(db_path('another_db'))

      expect(another_instance).to be_a(described_class)
      expect(File.exist?(db_path('another_db', for_constructor: false))).to be(true)
    end
  end

  describe '#save_changes' do
    it 'persists the expected structure to disk' do
      managertests = manager['managertests']

      managertests.insert_one(default_data_to_insert)
      managertests.register_all_changes
      manager.save_changes

      expect(jsonify_db_file).to eq(default_struct_with_expected_group)
    end
  end

  describe '#[]' do
    it 'returns a data mapper instance' do
      expect(manager['selected_group']).to be_a(FunnyDb::DataMapper)
    end
  end

  describe 'database file structure' do
    it 'matches the default structure after initialization' do
      expect(jsonify_db_file).to eq(default_structure)
    end
  end
end
# rubocop:enable Metrics/BlockLength
