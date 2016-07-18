class FfxParser
  def initialize(html)
    @html = html
  end

  def noko_page
    @noko_page ||= Nokogiri::HTML(@html)
  end

  def parse
    house = {
      sales: [],
      assessments: [],
      owner: []
    }
    #Gathers the owner(s)
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
      house[:sales] << Sale.new(sale) if row_index > 1
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
          assessment
        end
      end
      house[:assessments] << Assessment.new(assessment) if row_index > 1
    end

    #Gathers the external house and district data
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

    #Separates the street number, street and street type.  Could have problems and should update regex
    # This is now in the model
    # house[:street] = house[:address].gsub(/^((\d[a-zA-Z])|[^a-zA-Z])*/, '')
    # matches = house[:address].match(/^(?<number>\S*)\s+(?<name>.*)\s+(?<type>.*)$/)
    # house[:street_number] = matches[:number]
    # house[:street_type] = matches[:type]

    #Gathers the Legal Description
    noko_page.search("div[name=FULL_LEGAL] tr").each_with_index do |row, row_index|
     row.search("td").each_with_index do |cell, cell_index|
       house[:subdivision] = cell.text if row_index ==1 && cell_index == 1
       house[:lot_number] = cell.text if row_index == 2 && cell_index == 1
     end
    end

    #Gathers the House interior data
    noko_page.search("div[name=RESIDENTIAL] tr").each_with_index do |row, row_index|
     row.search("td").each_with_index do |cell, cell_index|
       p [row_index, cell_index, cell.text]
     end
    end

    #Gathers the
    #noko_page.search("div[name=STRUCTURE] tr").each_with_index do |row, row_index|
    #  row.search("td").each_with_index do |cell, cell_index|
    #    p [row_index, cell_index, cell.text]
    #  end
    #end

    House.create(house)
  end
end
