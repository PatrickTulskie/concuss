class Concuss::Headers
  attr_reader :header_set, :file

  STANDARD_HEADERS = [
    'Accept',
    'Accept-Charset',
    'Accept-Encoding',
    'Accept-Language',
    'Accept-Datetime',
    'Authorization',
    'Cache-Control',
    'Connection',
    'Cookie',
    'Content-Length',
    'Content-MD5',
    'Content-Type',
    'Date',
    'Expect',
    'From',
    'Host',
    'If-Match',
    'If-Modified-Since',
    'If-None-Match',
    'If-Range',
    'If-Unmodified-Since',
    'Max-Forwards',
    'Origin',
    'Pragma',
    'Proxy-Authorization',
    'Range',
    'Referer',
    'TE',
    'User-Agent',
    'Upgrade',
    'Via',
    'Warning'
  ]

  NON_STANDARD_HEADERS = [
    'X-Requested-With',
    'X-Forwarded-For',
    'X-Forwarded-Proto',
    'X-Http-Method-Override',
    'X-CSRF-Token'
  ]

  def initialize(header_set:, file: nil)
    @header_set = header_set
    @file = file
  end

  def group
    case @header_set
    when :standard
      STANDARD_HEADERS
    when :non_standard
      NON_STANDARD_HEADERS
    when :all
      STANDARD_HEADERS + NON_STANDARD_HEADERS
    when :file
      read_file(@file)
    else
      fail "Invalid header set"
    end
  end

  private

  def read_file(file_path)
    lines = []
    File.open(file_path, "r") do |file|
      file.each_line do |line|
        lines << line.strip
      end
    end
    lines
  end
end

