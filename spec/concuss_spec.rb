# frozen_string_literal: true

RSpec.describe Concuss do
  let(:user_agent) { 'Mozilla/5.0' }

  it "has a version number" do
    expect(Concuss::VERSION).not_to be nil
  end

  describe '#initialize' do
    let(:file_path) { 'file.txt' }
    let(:fake_headers) { ['EXAMPLE', 'X-EXAMPLE'] }

    it 'sets the attributes correctly' do
       # Stub out a header file
      headers = Concuss::Headers.new(header_set: :file, file: file_path)
      allow(headers).to receive(:read_file).with(file_path).and_return(fake_headers)
      allow(Concuss::Headers).to receive(:new).and_return(headers)

      concuss = Concuss.new(
        url: 'https://example.com',
        file: file_path,
        test_string: 'example',
        user_agent: user_agent,
        progress_type: :dots,
        formatter: Concuss::Formatters::Table
      )

      expect(concuss.url).to eq('https://example.com')
      expect(concuss.file).to eq(file_path)
      expect(concuss.header_set).to eq(:file)
      expect(concuss.test_string).to eq('example')
      expect(concuss.headers).to eq(fake_headers)
      expect(concuss.user_agent).to eq(user_agent)
      expect(concuss.progress_type).to eq(:dots)
      expect(concuss.formatter).to eq(Concuss::Formatters::Table)
    end

    it 'sets a default header_set if none are passed in' do
      concuss = Concuss.new(url: "https://example.com")
      expect(concuss.header_set).to eq(:all)
      expect(concuss.headers).to eq(Concuss::Headers.new(header_set: :all).group)
    end

    it 'raises an error if url is not provided' do
      expect { Concuss.new }.to raise_error(ArgumentError)
    end
  end

  describe '#attack!' do
    it 'creates a new instance of Concuss::Runner' do
      concuss = Concuss.new(url: 'https://example.com', user_agent: user_agent)
      runner = double('runner')
      expect(runner).to receive(:run)
      expect(Concuss::Runner).to receive(:new).with(
        url: 'https://example.com',
        user_agent: user_agent,
        headers: Concuss::Headers.new(header_set: :all).group,
        test_string: nil,
        progress_type: nil
      ).and_return(runner)
      concuss.attack!
    end
  end

end
