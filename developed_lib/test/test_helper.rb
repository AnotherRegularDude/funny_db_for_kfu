require 'funny_db'
require 'fileutils'
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

require 'minitest/autorun'
