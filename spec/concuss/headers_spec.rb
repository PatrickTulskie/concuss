require 'spec_helper'

RSpec.describe Concuss::Headers do
  let(:headers) { Concuss::Headers.new(header_set: :standard, file: "file.txt") }

  describe '#initialize' do
    it 'sets the header_set and file instance variables' do
      expect(headers.header_set).to eq(:standard)
      expect(headers.file).to eq("file.txt")
    end
  end

  describe '#headers' do
    it 'returns the standard headers when header_set is :standard' do
      headers = Concuss::Headers.new(header_set: :standard)
      expect(headers.group).to eq(Concuss::Headers::STANDARD_HEADERS)
    end

    it 'returns the non-standard headers when header_set is :non_standard' do
      headers = Concuss::Headers.new(header_set: :non_standard)
      expect(headers.group).to eq(Concuss::Headers::NON_STANDARD_HEADERS)
    end

    it 'returns all headers when header_set is :all' do
      headers = Concuss::Headers.new(header_set: :all)
      expect(headers.group).to eq(Concuss::Headers::STANDARD_HEADERS + Concuss::Headers::NON_STANDARD_HEADERS)
    end

    it 'returns the file content when header_set is :file' do
      file_path = 'file.txt'
      concuss = Concuss::Headers.new(header_set: :file, file: file_path)
      allow(concuss).to receive(:read_file).with(file_path).and_return(["content1", "content2"])
      expect(concuss.group).to eq(["content1", "content2"])
    end
  end
end

