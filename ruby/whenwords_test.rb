# frozen_string_literal: true

require 'minitest/autorun'
require 'yaml'
require_relative 'whenwords'

class WhenwordsTest < Minitest::Test
  TESTS = YAML.load_file(File.join(__dir__, '..', '..', 'tests.yaml'))

  # Generate timeago tests
  TESTS['timeago']&.each do |test_case|
    test_name = test_case['name'].gsub(/[^a-zA-Z0-9]/, '_').downcase
    define_method("test_timeago_#{test_name}") do
      input = test_case['input']
      if test_case['error']
        assert_raises(ArgumentError) do
          Whenwords.timeago(input['timestamp'], input['reference'])
        end
      else
        result = Whenwords.timeago(input['timestamp'], input['reference'])
        assert_equal test_case['output'], result, "Failed: #{test_case['name']}"
      end
    end
  end

  # Generate duration tests
  TESTS['duration']&.each do |test_case|
    test_name = test_case['name'].gsub(/[^a-zA-Z0-9]/, '_').downcase
    define_method("test_duration_#{test_name}") do
      input = test_case['input']
      options = input['options'] || {}
      # Convert string keys to symbols
      options = options.transform_keys(&:to_sym)

      if test_case['error']
        assert_raises(ArgumentError) do
          Whenwords.duration(input['seconds'], options)
        end
      else
        result = Whenwords.duration(input['seconds'], options)
        assert_equal test_case['output'], result, "Failed: #{test_case['name']}"
      end
    end
  end

  # Generate parse_duration tests
  TESTS['parse_duration']&.each do |test_case|
    test_name = test_case['name'].gsub(/[^a-zA-Z0-9]/, '_').downcase
    define_method("test_parse_duration_#{test_name}") do
      input = test_case['input']
      if test_case['error']
        assert_raises(ArgumentError) do
          Whenwords.parse_duration(input)
        end
      else
        result = Whenwords.parse_duration(input)
        assert_equal test_case['output'], result, "Failed: #{test_case['name']}"
      end
    end
  end

  # Generate human_date tests
  TESTS['human_date']&.each do |test_case|
    test_name = test_case['name'].gsub(/[^a-zA-Z0-9]/, '_').downcase
    define_method("test_human_date_#{test_name}") do
      input = test_case['input']
      if test_case['error']
        assert_raises(ArgumentError) do
          Whenwords.human_date(input['timestamp'], input['reference'])
        end
      else
        result = Whenwords.human_date(input['timestamp'], input['reference'])
        assert_equal test_case['output'], result, "Failed: #{test_case['name']}"
      end
    end
  end

  # Generate date_range tests
  TESTS['date_range']&.each do |test_case|
    test_name = test_case['name'].gsub(/[^a-zA-Z0-9]/, '_').downcase
    define_method("test_date_range_#{test_name}") do
      input = test_case['input']
      if test_case['error']
        assert_raises(ArgumentError) do
          Whenwords.date_range(input['start'], input['end'])
        end
      else
        result = Whenwords.date_range(input['start'], input['end'])
        assert_equal test_case['output'], result, "Failed: #{test_case['name']}"
      end
    end
  end
end
