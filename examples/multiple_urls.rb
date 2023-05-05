require 'concuss'

urls = [
  'http://localhost:4567/',
  'http://localhost:4567/about',
  'http://localhost:4567/admin'
]

urls.each do |url|
  puts "Testing URL: #{url}"
  concuss = Concuss.new(url, headers: :all)
  results = concuss.attack!
  results.each do |header, values|
    puts "#{header} - #{values[:response_code]}" if values[:hit]
  end
end
