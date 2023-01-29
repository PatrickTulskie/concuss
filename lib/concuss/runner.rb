require 'securerandom'
require 'net/http'

class Concuss::Runner
  DEFAULT_USER_AGENT = "Concuss/#{Concuss::VERSION}"
  
  attr_reader :headers, :url, :test_string, :user_agent

  def initialize(headers:, url:, test_string: nil, user_agent: nil)
    @headers = headers
    @url = url
    @test_string = test_string || SecureRandom.hex(25)
    @user_agent = user_agent || DEFAULT_USER_AGENT
  end

  def run
    uri = URI(@url)

    @headers.each do |header|
      response = Net::HTTP.get_response(uri,
        {
          header => test_string,
          'User-Agent' => user_agent
        }
      )

      if response.code == "200" && response.body.include?(@test_string)
        result = "HIT"
      else
        result = "MISS"
      end

      puts "#{header} - #{response.code} - #{result}"
    end
  end
end

