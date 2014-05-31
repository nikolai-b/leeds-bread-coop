# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

collection_points = CollectionPoint.create([
  {name: "Green Action", address: "LUU", post_code: 'LS2 ...', notes: "Nice students"},
  {name: "LILAC", address: "Kirstall", post_code: 'LS? ...', notes: "Very eco"}
])

bread_types = BreadType.create([
  {name: "Rye Sour Loaf", sour_dough: true, notes: "Tates great!"},
  {name: "Chabata", sour_dough: false, notes: "I doubt it is spelt like this"}
])

email_templates = EmailTemplate.create([name: "new_sub", body: "Welcome!"])
