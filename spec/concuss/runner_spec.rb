require 'spec_helper'

RSpec.describe Concuss::Runner do
  let(:headers) { ['X-Test-Header1', 'X-Test-Header2'] }
  let(:url) { 'http://test.com' }
  let(:test_string) { 'teststring' }
  let(:runner) { Concuss::Runner.new(headers: headers, url: url, test_string: test_string) }

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
  end

  describe '#run' do
    before(:each) do
      # mock the request to return a 200 status code
      allow(Net::HTTP).to receive(:get_response).and_return(double(code: '200', body: test_string))
    end

    it 'sends a request for each of the headers' do
      allow(Net::HTTP).to receive(:get_response).and_return(double(code: '200', body: test_string)).twice
      runner.run
    end

    it 'outputs the header, status code, and result' do
      expect { runner.run }.to output("X-Test-Header1 - 200 - HIT\nX-Test-Header2 - 200 - HIT\n").to_stdout
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

