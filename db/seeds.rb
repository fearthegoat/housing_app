# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

House.destroy_all
Owner.destroy_all
Pastaddress.destroy_all
Pastowner.destroy_all
Address.destroy_all

kevin = House.new
kevin.map_number = 111111
kevin.number = 100
kevin.street = "Main St"
kevin.street_type = "St"
kevin.owner_first_name = "John"
kevin.owner_last_name = "Smith"
kevin.zip_code = 22315
kevin.save!

t = Owner.new
t.name = "John Smith J"
t.first_name = "John"
t.last_name = "Smith"
t.middle_name = "J"
t.street_number = 2931
t.street = "Fort Tr"
t.zipcode = 82732
t.state = "VT"
t.save!

l = Owner.new
l.name = "Sarah Smith K"
l.first_name = "Sarah"
l.last_name = "Smith"
l.middle_name = "J"
l.street_number = 2931
l.street = "Fort Tr"
l.zipcode = 82732
l.state = "VT"
l.save!

address = Address.new
address.street_number = 2931
address.street = "Fort Tr"
address.zip_code = 82732
address.state = "VT"
address.save!

a = Pastaddress.new
a.address_id = address.id
a.owner_id = l.id
a.information_date = Time.now
a.save!

b = Pastaddress.new
b.address_id = address.id
b.owner_id = t.id
b.information_date = Time.now
b.save!

c = Pastowner.new
c.owner_id = l.id
c.house_id = kevin.id
c.save!

d = Pastowner.new
d.owner_id = t.id
d.house_id = kevin.id
d.save!
