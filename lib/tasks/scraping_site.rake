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

  #Summary.all.each do |summary|
  #  page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/Datalets/PrintDatalet.aspx?pin=#{summary.map_number}&gsp=PROFILEALL&taxyear=2017&jur=129&ownseq=0&card=1&roll=REAL&State=1&item=1&items=-1&all=all&ranks=Datalet')
  #  File.write(File.join(Rails.root, "..", "ffx-records-data" , "#{map_number}.html"), page.body)
  #end


  map_numbers.each do |map_number|
    page = mechanize.get(Scraper.ffx_url(map_number))
    File.write(File.join(Rails.root, "..", "ffx-records-data" , "#{map_number}.html"), page.body)
  end
end

task :parse_files do
  # houses = []

  Dir.glob("../ffx-records-data/*").each do |html|
    noko_page = Nokogiri::HTML(File.open(html))

    # house = {
    #   sales: []
    # }

    noko_page.search("div[name=SALES] tr").each_with_index do |row, row_index|
      row.search("td").each_with_index do |cell, cell_index|

        p [ row_index, cell_index, cell.text ]
      end
    end

    # p house

    # houses << house
  end


end


