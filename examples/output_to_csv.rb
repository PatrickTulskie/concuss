require 'concuss'

# Define the URL to test and the output file.
url = 'https://localhost:4567'
output_file = 'results.csv'

# Define the header set to test and create a `Concuss` object.
concuss = Concuss.new(url, header_set: :all)

# Run the attack and generate the report.
report = concuss.attack!
formatter = Concuss::Formatters::Table.new(report)
formatter.print

# Save the results to a CSV file.
CSV.open(output_file, 'w') do |csv|
  csv << ['Header', 'Response Code', 'Hit or Miss']
  report.data.each do |header, values|
    csv << [header, values[:response_code], values[:hit] ? 'Hit' : 'Miss']
  end
end
