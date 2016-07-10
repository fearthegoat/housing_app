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

  #OIOIeach do |html|

  html = "../ffx-records-data/0022030011.html"
  noko_page = Nokogiri::HTML(File.open(html))

  house = {
    sales: [],
    assessments: [],
    owner: []
  }

  noko_page.search("div[name=SALES] tr").each_with_index do |row, row_index|
    sale = Hash.new
    row.search("td").each_with_index do |cell, cell_index|
      p row_index
      if row_index > 1
        sale[:date] = cell.text if cell_index == 0
        sale[:amount] = cell.text if cell_index == 1
        sale[:seller] = cell.text if cell_index == 2
        sale[:buyer] = cell.text if cell_index == 3
      end
    end
    house[:sales] << sale if row_index > 1

   # end

    # p house

    # houses << house
  end

  owner = Hash.new
  noko_page.search("div[name=OWNER] tr").each_with_index do |row, row_index|
    row.search("td").each_with_index do |cell, cell_index|
      if row_index == 1
        owner[:name] = cell.text if cell_index == 1
      end
      if row_index == 2
        owner[:address] = cell.text if cell_index == 1
      end
      if row_index == 3
        owner[:book] = cell.text if cell_index == 1
      end
      if row_index == 4
        owner[:page] = cell.text if cell_index == 1
      end
    end
  end
  house[:owner] << owner

    noko_page.search("div[name=VALUES_HIST] tr").each_with_index do |row, row_index|
    assessment = Hash.new
    row.search("td").each_with_index do |cell, cell_index|
      if row_index > 1
        assessment[:year] = cell.text if cell_index == 0
        assessment[:land_value] = cell.text if cell_index == 1
        assessment[:building_value] = cell.text if cell_index == 2
        assessment[:total_value] = cell.text if cell_index == 3
        assessment[:tax_exempt?] = cell.text if cell_index == 4
      end
    end
    house[:assessments] << assessment if row_index > 1

   # end

    # p house

    # houses << house
  end
  binding.pry
end


