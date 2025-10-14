# frozen_string_literal: true

require 'funny_db'
require 'fileutils'
require 'ostruct'
require 'digest'
require 'rspec'

module SpecHelpers
  SPEC_TMP = File.expand_path('tmp', __dir__)

  def clear_tmp
    SpecHelpers.ensure_tmp_exists
    FileUtils.rm_rf(Dir[File.join(SPEC_TMP, '*')])
  end

  def db_path(db_name = 'test_db', for_constructor: true)
    SpecHelpers.ensure_tmp_exists
    final_db_name = for_constructor ? db_name : "#{db_name}.db.json"
    File.join(SPEC_TMP, final_db_name)
  end

  def structurized_manager_instance_init
    SpecHelpers.ensure_tmp_exists
    mi_holder = OpenStruct.new
    mi_holder.instance = FunnyDb::Manager.new(db_path)
    mi_holder.head = mi_holder.instance.instance_variable_get(:@head)
    mi_holder.body = mi_holder.instance.instance_variable_get(:@body)
    mi_holder
  end

  def structurized_data_mapper(mapper_name = 'maptests')
    mi_holder = structurized_manager_instance_init
    mapper = FunnyDb::DataMapper.new(mapper_name, mi_holder.instance)

    OpenStruct.new(holder: mi_holder, mapper: mapper)
  end

  module_function

  def ensure_tmp_exists
    FileUtils.mkdir_p(SPEC_TMP)
  end
end

RSpec.configure do |config|
  config.include SpecHelpers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) { SpecHelpers.ensure_tmp_exists }
  config.before(:each) { clear_tmp }
  config.after(:each) { clear_tmp }
end
