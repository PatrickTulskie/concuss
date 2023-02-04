require 'securerandom'
require 'net/http'

class Concuss::Runner
  DEFAULT_USER_AGENT = "Concuss/#{Concuss::VERSION}"

  attr_reader :headers, :url, :test_string, :user_agent, :progress_type

  def initialize(headers:, url:, test_string: nil, user_agent: nil, progress_type: nil)
    @headers = headers
    @url = url
    @test_string = test_string || SecureRandom.hex(25)
    @user_agent = user_agent || DEFAULT_USER_AGENT
    @progress_type = progress_type
  end

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

