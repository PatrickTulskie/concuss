concuss = Concuss.new(
  url: 'http://localhost:4567',
  header_set: :all,
  test_string: "OOGABOOGA"
)

report = concuss.attack!

Concuss::Formatter::Table.new(report).print
