# frozen_string_literal: true

RSpec.describe Concuss do
  it "has a version number" do
    expect(Concuss::VERSION).not_to be nil
  end

  describe '#initialize' do
    it 'sets the attributes correctly' do
      concuss = Concuss.new(
        url: 'https://example.com',
        file: 'example.txt',
        header_set: :all,
        test_string: 'example'
      )
      expect(concuss.url).to eq('https://example.com')
      expect(concuss.file).to eq('example.txt')
      expect(concuss.header_set).to eq(:all)
      expect(concuss.test_string).to eq('example')
      expect(concuss.headers).to eq(Concuss::Headers.new(header_set: :all).group)
    end

    it 'raises an error if url is not provided' do
      expect { Concuss.new }.to raise_error(ArgumentError)
    end
  end

  describe '#attack!' do
    it 'creates a new instance of Concuss::Runner' do
      concuss = Concuss.new(url: 'https://example.com')
      runner = double('runner')
      expect(runner).to receive(:run)
      expect(Concuss::Runner).to receive(:new).with(url: 'https://example.com', headers: Concuss::Headers.new(header_set: :all).group, test_string: nil).and_return(runner)
      concuss.attack!
    end
  end

end
