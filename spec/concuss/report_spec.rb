require 'rspec'

RSpec.describe Concuss::Report do
  let(:data) do
    {
      'header_1' => { response_code: '200', hit: true },
      'header_2' => { response_code: '404', hit: false },
      'header_3' => { response_code: '500', hit: true }
    }
  end

  subject { described_class.new(data: data, url: "http://example.com") }

  describe '#hits' do
    it 'returns the header/value pairs where hit is true' do
      expect(subject.hits).to eq({
        'header_1' => { response_code: '200', hit: true },
        'header_3' => { response_code: '500', hit: true }
      })
    end
  end

  describe '#misses' do
    it 'returns the header/value pairs where hit is false' do
      expect(subject.misses).to eq({
        'header_2' => { response_code: '404', hit: false }
      })
    end
  end

  describe '#headers' do
    it 'returns the headers' do
      expect(subject.headers).to eq(['header_1', 'header_2', 'header_3'])
    end
  end
end

