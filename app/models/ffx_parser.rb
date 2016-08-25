class FfxParser
  def initialize(html)
    @html = html
  end

  def noko_page
    @noko_page ||= Nokogiri::HTML(@html)
  end

  def house
    @house ||= House.new
  end

  def parse
    binding.pry
  end

  def current_owners #assigns mailing address to the owner
    return @current_owners unless @current_owners.nil?

    primary_names    = primary_owner_table.css("tr:first-child td:last-child").text.split(',').compact
    additional_names = noko_page.css("table[id='Additional Owners'] tr td.DataletData:first-child").map(&:text)

    address = Address.create(entire_address: primary_owner_table.css("tr:nth-child(2) td:last-child").text)
    sale = Sale.new
    cells = sales_history_table.css("tr")[1].search("td").map(&:text)
      
      if cells.size == 4
        sale.sales_date = cells[0]
        sale.amount = cells[1][1..-1].gsub(',','').to_f
        seller = Owner.create(name: cells[2])
        seller.save!
        sale.save!

        sale.pastsales.create(
        sale: sale,
        owner: seller,  #doesn't work, needs the model Owner and not the person's name
        transaction_side: 1
        )
      end

    @current_owners = (primary_names + additional_names).map do |name|
      owner = Owner.create(name: name)
      
      owner.pastaddresses.create(
        address: address,
        owner: owner,
        date_of_information: sale_dates.first
      )

      owner.save

      owner

      sale.pastsales.create(
        sale: sale,
        owner: owner,  #doesn't work, needs the model Owner and not the person's name
        transaction_side: 0
        )
    end 
  end


#DONE THROUGH HERE KEVIN
  def sales
    @sales ||= sales_history_table.css("tr")[2..-2].map do |row|
      sale = Sale.new
      cells = row.search("td").map(&:text)
   
      if cells.size == 4
        sale.sales_date = cells[0]
        sale.amount = cells[1][1..-1].gsub(',','').to_f
        sale.seller = cells[2]
        sale.buyer = cells[3]
        #add attribute buyer
        sale.save!
      end

    end
  end 

  def past_owners
    return @past_owners unless @past_owners.nil?


    @past_owners ||= sales.flat_map(&:pastsales).map(&:owner).uniq.reject do |owner|
      owner.name.nil? || owner.name.empty?
    end
  end

  def primary_owner_table
    @primary_owner_table ||= noko_page.css("table#Owner")
  end

  def sales_history_table
    @sales_history_table ||= noko_page.css("table[id='Sales History']")
  end

  def sale_dates
    @sale_dates ||= sales_history_table.css("tr td.DataletData:first-child").map(&:text)
  end

  def parse_house
    noko_page.search("div[name=SALES] tr")[2...-1].each do |row|
      sale = Sale.new


      house.sales << sale
      pastsale = Pastsale.new(sale: sale, owner: owner)
    end

    noko_page.search("div[name=OWNER] tr").each_with_index do |row, row_index|
      row.search("td").each_with_index do |cell, cell_index|
        if row_index == 1 && cell_index == 1
          owner.name = cell.text
        end
        
        if row_index == 2 && cell_index == 1
          address     = Address.create(entire_address: cell.text)
          pastaddress = Pastaddress.create(owner: owner, address: address, date_of_information: sales_date)
        end
        #if row_index == 3
        #  owner[:book] = cell.text if cell_index == 1
        #end
        #if row_index == 4
        #  owner[:page] = cell.text if cell_index == 1
        #end
      end
    end

    house.owners << owner
    
    if noko_page.at_css("div[name=OWN_ADD] tr")
      
      noko_page.css("table[id='Additional Owners'] tr td.DataletData:first-child").each do |cell|
        additional_owner = Owner.create(name: cell.text)
        pastaddress      = Pastaddress.create(owner: additional_owner, address: address, date_of_information: sales_date)

        house.owners << additional_owner
      end
      #owner2[:book] = owner[:book]
      #owner2[:page] = owner[:page]
    end

    #Gathers the sales


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
      house.assessments << Assessment.new(assessment) if row_index > 1
    end

    #Gathers the external house and district data
    info = []
    noko_page.search("div[name=COM_PARCEL] tr").each_with_index do |row, row_index|
     row.search("td").each_with_index do |cell, cell_index|
      info << cell.text
     end
    end
    house.address = info[2]
    house.map_number = info[4]
    house.tax_district = info[6]
    house.tax_district_name = info[8]
    house.land_use_code = info[10]
    house.land_acreage = info[12]
    house.land_sq_ft = info[14]
    house.zoning_description = info[16]
    house.county_historic_district = info[24]
    house.street_type = info[30]
    house.site_description = info[32]

    #Separates the street number, street and street type.  Could have problems and should update regex
    # This is now in the model
    # house[:street] = house[:address].gsub(/^((\d[a-zA-Z])|[^a-zA-Z])*/, '')
    # matches = house[:address].match(/^(?<number>\S*)\s+(?<name>.*)\s+(?<type>.*)$/)
    # house[:street_number] = matches[:number]
    # house[:street_type] = matches[:type]

    #Gathers the Legal Description
    noko_page.search("div[name=FULL_LEGAL] tr").each_with_index do |row, row_index|
     row.search("td").each_with_index do |cell, cell_index|
       house.subdivision = cell.text if row_index ==1 && cell_index == 1
       house.lot_number = cell.text if row_index == 2 && cell_index == 1
     end
    end

    #Gathers the House interior data
    noko_page.search("div[name=RESIDENTIAL] tr").each_with_index do |row, row_index|
     row.search("td").each_with_index do |cell, cell_index|
       #p [row_index, cell_index, cell.text]
     end
    end

    #Gathers the
    #noko_page.search("div[name=STRUCTURE] tr").each_with_index do |row, row_index|
    #  row.search("td").each_with_index do |cell, cell_index|
    #    p [row_index, cell_index, cell.text]
    #  end
    #end

    #House.create(house)
    house
  end
end
