RSpec::Matchers.define :include_html do |expected|
  def clean_html(s)
    s = s.squish.gsub(/>(\s)+</, "><")
    Nokogiri::HTML.fragment(s).to_xhtml(
      indent: 2, save_options: Nokogiri::XML::Node::SaveOptions::AS_HTML,
    )
  end

  match do |actual|
    @actual = clean_html(actual)
    @expected = clean_html(expected)
    @actual.include? @expected
  end

  failure_message do |_actual|
    "EXPECTED:\n#{@actual}\n\nTO INCLUDE:\n#{@expected}"
  end
end
