# The `Report` class is used to generate a report of the results of a Concuss attack on a given URL.
class Concuss::Report
  # The data collected during the attack, stored as a hash where the keys are the header names and the values are information about whether the header hit or missed.
  attr_reader :data

  # The URL that was targeted by the attack.
  attr_reader :url

  # Creates a new `Report` object.
  #
  # @param data [Hash] The data collected during the attack, stored as a hash where the keys are the header names and the values are information about whether the header hit or missed.
  # @param url [String] The URL that was targeted by the attack.
  def initialize(data:, url:)
    @url = url
    @data = data
  end

  # Returns a hash of headers that hit during the attack.
  #
  # @return [Hash] A hash of headers that hit during the attack.
  def hits
    data.select { |_, value| value[:hit] }
  end

  # Returns a hash of headers that missed during the attack.
  #
  # @return [Hash] A hash of headers that missed during the attack.
  def misses
    data.reject { |_, value| value[:hit] }
  end

  # Returns an array of header names collected during the attack.
  #
  # @return [Array] An array of header names collected during the attack.
  def headers
    data.keys
  end
end
