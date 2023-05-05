# The `Headers` class is used to group together a set of HTTP headers for use in a Concuss attack.
class Concuss::Headers

  # The set of headers to use in the attack.
  attr_reader :header_set

  # The path to a file containing a list of headers to use in the attack.
  attr_reader :file

  # The set of standard HTTP headers that will be used in the attack.
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
    'Upgrade',
    'Via',
    'Warning'
  ]

  # The set of non-standard HTTP headers that will be used in the attack.
  NON_STANDARD_HEADERS = [
    'X-Requested-With',
    'X-Forwarded-For',
    'X-Forwarded-Proto',
    'X-Http-Method-Override',
    'X-CSRF-Token'
  ]

  # Initializes a new `Headers` object.
  #
  # @param header_set [Symbol] The set of headers to use in the attack.
  # @param file [String] The path to a file containing a list of headers to use in the attack.
  def initialize(header_set:, file: nil)
    @header_set = header_set
    @file = file
  end

  # Returns the set of headers to use in the attack.a
  #
  # @return [Array<String>] The set of headers to use in the attack.
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

  # Reads a file containing a list of headers to use in the attack.
  # Each header should be on a separate line.
  #
  # @param file_path [String] The path to the file containing the list of headers.
  # @return [Array<String>] The list of headers to use in the attack.
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

