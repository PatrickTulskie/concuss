require 'rspec'

RSpec.describe Concuss::Formatters::Table do
  let(:data) do
    {
      'X-CSRF-TOKEN' => { response_code: '200', hit: true },
      'X-Requested-With' => { response_code: '404', hit: false },
      'X-Forwarded-Proto' => { response_code: '500', hit: true }
    }
  end

  let(:report) { Concuss::Report.new(data: data, url: "http://example.com") }
  subject { described_class.new(report) }

  describe '#print' do
    it 'outputs the data in a table format' do
      expected_output = <<-TABLE
HEADER            | RESPONSE_CODE | HIT/MISS
--------------------------------------------
X-CSRF-TOKEN      | 200           | HIT
X-Forwarded-Proto | 500           | HIT
X-Requested-With  | 404           | MISS
TABLE

      expect { subject.print }.to output(expected_output).to_stdout
    end
  end
end

