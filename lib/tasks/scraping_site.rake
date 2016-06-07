task scraping_site: :environment do
  mechanize = Mechanize.new

  page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/search/commonsearch.aspx?mode=parid')
  puts page.uri

  form = page.forms.first
  form['inpParid'] = "0401090035"
  results = form.submit

  #owner name and current address
  results.search('#Owner .DataletData').each_with_index do |entry, count|
    if count == 0
      entry.content.split(',').each {|owner| puts owner.strip}
    else
      puts(entry.content)
    end
  end

  results.search('#Parcel .DataletData').each_with_index do |entry, count|
    puts(entry.content)
  end
end

