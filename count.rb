require "nokogiri"
require "open-uri"

BASE = "http://hackerspace.govhack.org"
index_url = "#{BASE}/projects"
def project_url(location)
  "#{BASE}/#{location}"
end

votes = {}
open(index_url) do |index_page|
  html = Nokogiri::HTML(index_page.read)
  links = html.css("td.active a").map {|link| link["href"]}
  links.each do |link|
    open(project_url(link)) do |link_page|
      html = Nokogiri::HTML(link_page.read)
      summary = html.at_css(".fivestar-summary-average-count").text.strip
      title = html.at_css("#page-title").text.strip
      puts "#{title}: #{summary}"
      votes[title] = summary
    end
  end
end

votes.each do |k, v|
  puts "#{k}: #{v}"
end


