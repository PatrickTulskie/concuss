# The `Table` class is used to format the results of a Concuss attack as a table.
class Concuss::Formatters::Table
  # The headings for the table.
  HEADINGS = ['HEADER', 'RESPONSE_CODE', 'HIT/MISS'].freeze

  # Creates a new `Table` object.
  #
  # @param report [Concuss::Report] The report to be formatted.
  def initialize(report)
    @report = report
  end

  # Prints the table to the console.
  #
  # @return [nil]
  def print
    header_max_length = @report.headers.map(&:length).max
    response_code_length = HEADINGS[1].length
    hit_header_length = HEADINGS[2].length

    header_format = "%-#{header_max_length}s | %-#{response_code_length}s | %-0s\n"
    separator = '-' * (header_max_length + response_code_length + hit_header_length + 6)

    puts header_format % HEADINGS
    puts separator
    print_data(@report.hits, header_format)
    print_data(@report.misses, header_format)
  end

  private

  # Prints the data to the console in the specified format.
  #
  # @param data [Hash] The data to be printed.
  # @param header_format [String] The format string to use for the headers.
  # @return [nil]
  def print_data(data, header_format)
    data.sort.each do |header, values|
      puts header_format % [header, values[:response_code], values[:hit] ? 'HIT' : 'MISS']
    end
  end
end

