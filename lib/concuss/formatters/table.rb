class Concuss::Formatters::Table

  HEADINGS = ['HEADER', 'RESPONSE_CODE', 'HIT/MISS'].freeze

  def initialize(report)
    @report = report
  end

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

  def print_data(data, header_format)
    data.sort.each do |header, values|
      puts header_format % [header, values[:response_code], values[:hit] ? 'HIT' : 'MISS']
    end
  end
end

