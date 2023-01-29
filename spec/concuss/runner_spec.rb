require 'spec_helper'

RSpec.describe Concuss::Runner do
  let(:headers) { ['X-Test-Header1', 'X-Test-Header2'] }
  let(:url) { 'http://test.com' }
  let(:test_string) { 'teststring' }
  let(:runner) { Concuss::Runner.new(headers: headers, url: url, test_string: test_string, user_agent: user_agent) }
  let(:user_agent) { 'Mozilla/5.0' }

  describe '#initialize' do
    it 'sets the headers' do
      expect(runner.headers).to eq(headers)
    end

    it 'sets the url' do
      expect(runner.url).to eq(url)
    end

    it 'sets the test string' do
      expect(runner.test_string).to eq(test_string)
    end

    it 'sets the user_agent' do
      expect(runner.user_agent).to eq(user_agent)
    end
  end

  describe '#run' do
    let(:mock_response) { double(code: '200', body: test_string) }

    before(:each) do
      # mock the request to return a 200 status code
      allow(Net::HTTP).to receive(:get_response).and_return(mock_response)
    end

    it 'sends a request for each of the headers' do
      allow(Net::HTTP).to receive(:get_response).and_return(mock_response).twice
      runner.run
    end

    it 'outputs the header, status code, and result' do
      expect { runner.run }.to output("X-Test-Header1 - 200 - HIT\nX-Test-Header2 - 200 - HIT\n").to_stdout
    end

    it 'uses the custom user_agent' do
      expect(Net::HTTP).to receive(:get_response).with(URI(url),
        {
          'User-Agent' => user_agent,
          headers.first => test_string
        }
      )
      runner.run
    end

    it 'uses the DEFAULT_USER_AGENT' do
      runner = Concuss::Runner.new(headers: headers, url: url, test_string: test_string)
      expect(Net::HTTP).to receive(:get_response).with(URI(url),
        {
          'User-Agent' => Concuss::Runner::DEFAULT_USER_AGENT,
          headers.first => test_string
        }
      )
      runner.run
    end

    context 'when the response body does not include the test string' do
      before(:each) do
        # mock the request to return a 200 status code and body without the test string
        allow(Net::HTTP).to receive(:get_response).and_return(double(code: '200', body: 'no match'))
      end

      it 'outputs "MISS" for the result' do
        expect { runner.run }.to output("X-Test-Header1 - 200 - MISS\nX-Test-Header2 - 200 - MISS\n").to_stdout
      end
    end
  end
end

