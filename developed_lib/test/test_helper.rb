require 'funny_db'
require 'minitest/reporters'

Minitest::Reporters.use! [
  Minitest::Reporters::SpecReporter.new,
  Minitest::Reporters::MeanTimeReporter.new
]

require 'minitest/autorun'
