require 'pry'

module Scraper
  def self.ffx_url(map_number)
    "http://icare.fairfaxcounty.gov/ffxcare/Datalets/PrintDatalet.aspx?pin=#{map_number}&gsp=PROFILEALL&taxyear=2017&jur=129&ownseq=0&card=1&roll=REAL&State=1&item=1&items=-1&all=all&ranks=Datalet"
  end
end

task scraping_site: :environment do

  mechanize = Mechanize.new

  map_numbers = ["0022020031",
  "0022020032",
  "0022030005",
  "0022030009",
  "0022030010",
  "0022030011",
  "0022030014A",
  "0022030015A",
  "0022030016",
  "002203020001"]

  finished = Dir.glob("../ffx-records-data/*")
  finished_map_numbers = finished.inject([]) { |results, file_path| results << file_path[/(?<=data\/)(.*)(?=.html)/,1]}
  total = Summary.all.map(&:map_number)
  remaining = total - finished_map_numbers
  remaining.each do |map_number|
   page = mechanize.get(Scraper.ffx_url(map_number))
   puts(map_number)
   File.write(File.join(Rails.root, "..", "ffx-records-data" , "#{map_number}.html"), page.body)
  end


#  map_numbers.each do |map_number|
 #   page = mechanize.get(Scraper.ffx_url(map_number))
  #  File.write(File.join(Rails.root, "..", "ffx-records-data" , "#{map_number}.html"), page.body)
  #end
end

task :parse_files do
  # houses = []

  html = "../ffx-records-data/0022030011.html"

  house = FfxParser.new(File.open(html)).parse

  binding.pry
end

#THINGS TO ASK RUSSELL in order of importance
#schema
#maybe do a match of name instead of hard coding the cell and row index numbers
#regex improvement for separating street number, street and street type.
