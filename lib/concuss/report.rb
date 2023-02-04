class Concuss::Report
  attr_reader :data, :url

  def initialize(data:, url:)
    @url = url
    @data = data
  end

  def hits
    data.select { |_, value| value[:hit] }
  end

  def misses
    data.reject { |_, value| value[:hit] }
  end

  def headers
    data.keys
  end
end
