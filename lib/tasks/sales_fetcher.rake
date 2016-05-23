task sales_fetcher: :environment do
  mechanize = Mechanize.new

  page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/main/home.aspx')
  puts page.uri

  link = page.link_with(text: 'Property Search')

  page = link.click

  puts page.uri

  form = page.forms.first

  form['inpStreet'] = 'm'
  form['inpSuffix1'] = ''
  form['selPageSize'] = '6500'
  page = form.submit
  #form.fields.each { |f| puts f.name }

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
    Summary.create(last_sale: @last_sale, map_number: @map_number,owner: @owner, street: @street, street_number: @street_number)
  end
end