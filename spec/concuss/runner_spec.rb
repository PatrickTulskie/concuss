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

    context 'when setting the progress_type' do
      let(:runner) { Concuss::Runner.new(headers: headers, url: url, progress_type: :dots) }

      it 'sets the progress_type' do
        expect(runner.progress_type).to eq(:dots)
      end
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

    it 'outputs the header, status code, and result when using full progress type' do
      runner.instance_variable_set(:@progress_type, :full)
      expected_output = <<-OUTPUT
X-Test-Header1 - 200 - HIT
X-Test-Header2 - 200 - HIT
OUTPUT
      output = capture_stdout { runner.run }
      expect(output).to eq(expected_output)
    end

    it 'outputs dots when using the dot progress type' do
      runner.instance_variable_set(:@progress_type, :dots)
      output = capture_stdout { runner.run }
      expect(output).to eq("..\n")
    end

    it 'returns a Report with the correct results' do
      report = runner.run

      expect(report).to be_a(Concuss::Report)
      expect(report.hits.keys.sort).to eq(headers)
      expect(report.hits.values.last[:response_code]).to eq('200')
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

      it 'outputs the header, status code, and result when using full progress type' do
        runner.instance_variable_set(:@progress_type, :full)
        expected_output = <<-OUTPUT
X-Test-Header1 - 200 - MISS
X-Test-Header2 - 200 - MISS
OUTPUT
      output = capture_stdout { runner.run }
      expect(output).to eq(expected_output)
    end

      it 'returns a Report with the correct results' do
        report = runner.run

        expect(report).to be_a(Concuss::Report)
        expect(report.misses.keys.sort).to eq(headers)
        expect(report.misses.values.last[:response_code]).to eq('200')
      end
    end
  end
end

