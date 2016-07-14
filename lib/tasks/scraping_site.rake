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
#Gathers the owner
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
  if noko_page.at_css("div[name=OWN_ADD] tr")
    owner2 = Hash.new
    noko_page.search("div[name=OWN_ADD] tr").each_with_index do |row, row_index|
      row.search("td").each_with_index do |cell, cell_index|
        owner2[:name] = cell.text if row_index == 2 && cell_index == 0
      end
    end
    owner2[:address] = owner[:address]
    owner2[:book] = owner[:book]
    owner2[:page] = owner[:page]
    house[:owner] << owner2
  end

  #Gathers the sales
  noko_page.search("div[name=SALES] tr").each_with_index do |row, row_index|
    sale = Hash.new
    row.search("td").each_with_index do |cell, cell_index|
      if row_index > 1
        sale[:date] = cell.text if cell_index == 0
        sale[:amount] = cell.text if cell_index == 1
        sale[:seller] = cell.text if cell_index == 2
        sale[:buyer] = cell.text if cell_index == 3
      end
    end
    house[:sales] << sale if row_index > 1
  end

  #Gathers the yearly assessments
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
  end

  #Gathers the
  info = []
  noko_page.search("div[name=COM_PARCEL] tr").each_with_index do |row, row_index|
   row.search("td").each_with_index do |cell, cell_index|
    info << cell.text
   end
  end
  house[:address] = info[2]
  house[:map_number] = info[4]
  house[:tax_district] = info[6]
  house[:tax_district_name] = info[8]
  house[:land_use_code] = info[10]
  house[:land_acreage] = info[12]
  house[:land_sq_ft] = info[14]
  house[:zoning_description] = info[16]
  house[:county_historic_district?] = info[24]
  house[:street_type] = info[30]
  house[:site_description] = info[32]
  binding.pry
  #Gathers the
  #noko_page.search("div[name=FULL_LEGAL] tr").each_with_index do |row, row_index|
  #  row.search("td").each_with_index do |cell, cell_index|
  #    p [row_index, cell_index, cell.text]
  #  end
  #end

  #Gathers the
  #noko_page.search("div[name=RESIDENTIAL] tr").each_with_index do |row, row_index|
  #  row.search("td").each_with_index do |cell, cell_index|
  #    p [row_index, cell_index, cell.text]
  #  end
  #end

  #Gathers the
  #noko_page.search("div[name=STRUCTURE] tr").each_with_index do |row, row_index|
  #  row.search("td").each_with_index do |cell, cell_index|
  #    p [row_index, cell_index, cell.text]
  #  end
  #end

  #binding.pry
end


