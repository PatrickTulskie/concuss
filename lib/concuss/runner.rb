require 'securerandom'
require 'net/http'

# The `Runner` class is used to run a Concuss attack on a given URL.
class Concuss::Runner
  # The default user agent string.
  DEFAULT_USER_AGENT = "Concuss/#{Concuss::VERSION}"

  # The headers that will be tested during the attack.
  attr_reader :headers

  # The URL that will be targeted by the attack.
  attr_reader :url

  # The test string that will be used to check whether a header is vulnerable.
  attr_reader :test_string

  # The user agent string that will be used for the attack.
  attr_reader :user_agent

  # The progress type for the attack (either :full, :dots, or nil).
  attr_reader :progress_type

  # Creates a new `Runner` object.
  #
  # @param headers [Array] The headers that will be tested during the attack.
  # @param url [String] The URL that will be targeted by the attack.
  # @param test_string [String, nil] The test string that will be used to check whether a header is vulnerable (optional).
  # @param user_agent [String, nil] The user agent string that will be used for the attack (optional).
  # @param progress_type [Symbol, nil] The progress type for the attack (either :full, :dots, or nil).
  def initialize(headers:, url:, test_string: nil, user_agent: nil, progress_type: nil)
    @headers = headers
    @url = url
    @test_string = test_string || SecureRandom.hex(25)
    @user_agent = user_agent || DEFAULT_USER_AGENT
    @progress_type = progress_type
  end

  # Runs the attack and returns a `Report` object containing the results.
  #
  # @return [Concuss::Report] A `Report` object containing the results of the attack.
  def run
    uri = URI(@url)
    report_data = { }

    @headers.each do |header|
      response = Net::HTTP.get_response(uri,
        {
          header => test_string,
          'User-Agent' => user_agent
        }
      )

      hit = response.code == "200" && response.body.include?(@test_string)
      report_data[header] = { response_code: response.code, hit: hit }

      case progress_type
      when :full
        puts "#{header} - #{response.code} - #{hit ? "HIT" : "MISS"}"
      when :dots
        print "."
      end
    end

    puts "" if progress_type == :dots

    return Concuss::Report.new(data: report_data, url: @url)
  end
end
