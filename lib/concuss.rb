# frozen_string_literal: true

# The `Concuss` class is used to perform HTTP header fuzzing.
class Concuss
  class Error < StandardError; end

  # The URL that will be targeted by the attack.
  attr_reader :url

  # The name of the file that will be used to specify attack headers (optional).
  attr_reader :file

  # The set of headers that will be used in the attack.
  attr_reader :header_set

  # The headers that will be used in the attack.
  attr_reader :headers

  # A string that will be used to test the response from the target server (optional).
  attr_reader :test_string

  # The user agent that will be used in the attack (optional).
  attr_reader :user_agent

  # The formatter that will be used to display the results of the attack (optional).
  attr_reader :formatter

  # The type of progress indicator that will be displayed during the attack (optional).
  attr_reader :progress_type

  # Creates a new `Concuss` object.
  #
  # @param url [String] The URL that will be targeted by the attack.
  # @param file [String, nil] The name of the file that will be used to specify attack headers (optional).
  # @param header_set [Symbol] The set of headers that will be used in the attack.
  # @param test_string [String, nil] A string that will be used to test the response from the target server (optional).
  # @param user_agent [String, nil] The user agent that will be used in the attack (optional).
  # @param formatter [Object, nil] The formatter that will be used to display the results of the attack (optional).
  # @param progress_type [Symbol, nil] The type of progress indicator that will be displayed during the attack (optional).
  def initialize(url:, file: nil, header_set: :all, test_string: nil, user_agent: nil, formatter: nil, progress_type: nil)
    @url = url
    @file = file
    @header_set = file.nil? ? header_set : :file
    @test_string = test_string
    @user_agent = user_agent
    @formatter = formatter
    @progress_type = progress_type

    # The headers that will be used in the attack.
    @headers = Concuss::Headers.new(header_set: @header_set, file: @file).group
  end

  # Runs the attack and returns the results.
  #
  # @return [Array] The results of the attack.
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
