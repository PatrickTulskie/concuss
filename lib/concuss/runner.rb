require 'securerandom'
require 'net/http'

class Concuss::Runner
  attr_reader :technique, :headers, :url, :test_string

  def initialize(technique:, headers:, url:, test_string: nil)
    @technique = technique
    @headers = headers
    @url = url
    @test_string = test_string || SecureRandom.hex(25)
  end

  def run
    uri = URI(@url)

    @headers.each do |header|
      response = Net::HTTP.get_response(uri,
        { header => test_string }
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

