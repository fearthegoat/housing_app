task sales_fetcher: :environment do
  mechanize = Mechanize.new

  page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/main/home.aspx')
  puts page.uri

  link = page.link_with(text: 'Property Search')

  page = link.click

  puts page.uri

  form = page.forms.first

  form['inpStreet'] = 'Fort'

  form['inpSuffix1'] = 'DR'
  form['selPageSize'] = '100'
  page = form.submit
  #form.fields.each { |f| puts f.name }

  page.search('.SearchResults td div').each do |tr|
    puts tr.content
  end

#SEARCH HOW TO NAVIGATE THROUGH CSS AND TABLES
  #form.fields.each { |f| puts f.name }
end

#<tr height="23" class="SearchResults"