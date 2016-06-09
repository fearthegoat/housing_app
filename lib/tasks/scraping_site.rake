task scraping_site: :environment do
  mechanize = Mechanize.new

  page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/search/commonsearch.aspx?mode=parid')
  puts page.uri

  form = page.forms.first
  form['inpParid'] = "0401090033"
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

#  link1 = page.link_with(text: 'Map Number')
 # puts link1



#SALES
page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/datalets/datalet.aspx?mode=sales&sIndex=0&idx=1&LMparent=138')

page.search('.DataletData').each_with_index do |entry, count|
  puts(entry.content)
end

#VALUES
page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/datalets/datalet.aspx?mode=valuesall&sIndex=1&idx=1&LMparent=138')

#STRUCTURE SIZE
page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/datalets/datalet.aspx?mode=structure_size&sIndex=1&idx=1&LMparent=138')

#RESIDENTIAL
page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/datalets/datalet.aspx?mode=resall&sIndex=1&idx=1&LMparent=138')

#COMMERCIAL
page = mechanize.get('http://icare.fairfaxcounty.gov/ffxcare/datalets/datalet.aspx?mode=com_combined&sIndex=1&idx=1&LMparent=138')


end

