require 'funny_db'
require 'fileutils'
require 'ostruct'

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

require 'minitest/autorun'
