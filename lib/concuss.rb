# frozen_string_literal: true

class Concuss
  class Error < StandardError; end

  attr_reader :url, :file, :header_set, :headers, :test_string

  def initialize(url:, file: nil, header_set: :all, test_string: nil)
    @url = url
    @file = file
    @header_set = header_set
    @test_string = test_string

    @headers = Concuss::Headers.new(header_set: header_set, file: file).group
  end

  def attack!
    runner = Concuss::Runner.new(headers: headers, url: url, test_string: test_string)

    runner.run
  end
end

require_relative "concuss/version"
require_relative "concuss/headers"
require_relative "concuss/runner"
