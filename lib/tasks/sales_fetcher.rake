task sales_fetcher: :environment do
  mechanize = Mechanize.new
#  max_number = 10
  page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/main/home.aspx')
  puts page.uri

  link = page.link_with(text: 'Property Search')

  page = link.click

  puts page.uri
  form = page.forms.first
  S = ['ALY','AV','AVE','BLVD','BV','CIR','CL','CMNS','CT','CTR','CV','DR','GRN','GRV','HTS','HWY','KNLS','LA','LN','LNDG','LOOP','LP','PARK','PASS','PATH','PIKE','PK','PKWY','PL','PLZ','PW','RD','RDG','ROAD','ROW','RUN','SQ','ST','TE','TER','TPKE','TR','TRCE','TRL','VW','WALK','WAY','WY','XING']
  @Starttime = Time.now
  def submit_form(number, form)
  form['inpStreet'] = ""
  form['inpSuffix1'] = ''
  form['inpNumber'] = "#{number}"
  form['selPageSize'] = '500'
  page = form.submit
  puts("Number of Results for '#{number}': #{page.search('.SearchResults').size}")
  page.search('.SearchResults').each_with_index do |raw, count|
    raw.search('td div').each_with_index do |entry, index|
      if index == 0 then  @map_number = entry.content.gsub(/\s+/, '')
        elsif index == 1 then @owner = entry.content
        elsif index == 2 then
        @street = entry.content.gsub(/^((\d[a-zA-Z])|[^a-zA-Z])*/, '')
        matches = entry.content.match(/^(?<number>\S*)\s+(?<name>.*)\s+(?<type>.*)$/)
        @street_number = matches[:number]
        else @last_sale = entry.content
      end
    end
      Trial.create(last_sale: @last_sale, map_number: @map_number,owner: @owner, street: @street, street_number: @street_number)
    end
    page.search('.SearchResults').size
  end
  # (1..50000).to_a.each do |number|
  #   return if number > max_number
  #   value = submit_form(number, form)
  #   max_number = "#{number}9".to_i if value == 500
  #   sleep(0.1)
  #   puts max_number
  #   puts "Search for #{number} completed"
  # end
  def looping(number, form)
    (0..9).to_a.each do |num|
      current_number = "#{number}#{num}".to_i
      value = submit_form(current_number, form)
      looping(current_number, form) if value == 500
    end
  end
  1..9.to_a.each do |number|
    looping(number, form)
  end
end

