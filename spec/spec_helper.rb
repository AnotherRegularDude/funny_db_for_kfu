# frozen_string_literal: true

require "funny_db"
require "fileutils"
require "digest"
require "rspec"
require "oj"

module Helpers
  extend self

  SPEC_TMP = File.expand_path("tmp", __dir__)
  ManagerFixture = Struct.new(:instance, :head, :body)
  MapperFixture = Struct.new(:holder, :mapper)

  def clear_tmp
    ensure_tmp_exists
    FileUtils.rm_rf(Dir[File.join(SPEC_TMP, "*")])
  end

  def db_path(db_name = "test_db", for_constructor: true)
    ensure_tmp_exists
    final_db_name = for_constructor ? db_name : "#{db_name}.db.json"
    File.join(SPEC_TMP, final_db_name)
  end

  def structurized_manager_instance_init
    ensure_tmp_exists
    manager_instance = FunnyDb::Manager.new(db_path)
    head = manager_instance.instance_variable_get(:@head)
    body = manager_instance.instance_variable_get(:@body)

    ManagerFixture.new(manager_instance, head, body)
  end

  def structurized_data_mapper(mapper_name = "maptests")
    manager_holder = structurized_manager_instance_init
    mapper = FunnyDb::DataMapper.new(mapper_name, manager_holder.instance)

    MapperFixture.new(manager_holder, mapper)
  end

  def default_head
    {
      hash: "",
      group_count: 0,
      locked: false,
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
      body: default_body,
    }

    result[:head][:hash] = calc_hash(result)

    result
  end

  def default_data_to_insert
    { name: "test1" }
  end

  def default_struct_with_expected_group(group: :managertests, data: default_data_to_insert)
    result = default_structure

    result[:head][:hash] = ""
    result[:body][group] = [data]

    result[:head][:hash] = calc_hash(result)

    result
  end

  def jsonify_db_file(db_name = "test_db")
    Oj.load(
      File.read(db_path(db_name, for_constructor: false)),
      FunnyDb::Manager::OJ_OPTIONS,
    )
  end

  def ensure_tmp_exists
    FileUtils.mkdir_p(SPEC_TMP)
  end
end

RSpec.configure do |config|
  config.include Helpers

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.expose_dsl_globally = true

  config.before(:suite) { Helpers.ensure_tmp_exists }
  config.before { clear_tmp }
  config.after { clear_tmp }
end
