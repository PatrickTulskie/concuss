# frozen_string_literal: true

class Concuss
  class Error < StandardError; end

  attr_reader :url, :file, :header_set, :headers, :test_string, :user_agent, :formatter, :progress_type

  def initialize(url:, file: nil, header_set: :all, test_string: nil, user_agent: nil, formatter: nil, progress_type: nil)
    @url = url
    @file = file
    @header_set = file.nil? ? header_set : :file
    @test_string = test_string
    @user_agent = user_agent
    @formatter = formatter
    @progress_type = progress_type

    @headers = Concuss::Headers.new(header_set: @header_set, file: @file).group
  end

  def attack!
    runner = Concuss::Runner.new(headers: headers, url: url, test_string: test_string, user_agent: user_agent, progress_type: progress_type)
    results = runner.run

    formatter.new(results).print if formatter

    return results
  end
end

require_relative "concuss/version"
require_relative "concuss/report"
require_relative "concuss/headers"
require_relative "concuss/runner"
require_relative "concuss/formatters"
