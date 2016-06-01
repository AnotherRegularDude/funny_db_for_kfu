require 'funny_db'

require 'fileutils'
require 'ostruct'
require 'digest'

require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::MeanTimeReporter.new
]

TEST_ROOT_DIR = File.dirname(__FILE__).freeze
TEST_TMP = File.join(TEST_ROOT_DIR, 'tmp').freeze

def clear_tmp
  FileUtils.rm_rf(Dir[File.join(TEST_TMP, '*')])
end

def db_path(db_name = 'test_db', for_constructor = true)
  final_db_name = if for_constructor
                    db_name
                  else
                    db_name + '.db.json'
                  end

  File.join(TEST_TMP, final_db_name)
end

def structurized_manager_instance_init
  mi_holder = OpenStruct.new
  mi_holder.instance = FunnyDb::Manager.new(db_path)
  mi_holder.head = mi_holder.instance.instance_variable_get(:@head)
  mi_holder.body = mi_holder.instance.instance_variable_get(:@body)

  mi_holder
end

require 'minitest/autorun'
