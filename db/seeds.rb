# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless (CollectionPoint.find_by name: 'Green Action')
  collection_points = CollectionPoint.create([
    {name: "Green Action", address: "LUU", post_code: 'LS2 ...', notes: "Nice students"},
    {name: "LILAC", address: "Kirstall", post_code: 'LS? ...', notes: "Very eco"}
  ])
end

unless (BreadType.find_by name: 'Rye Sour Loaf' )
  bread_types = BreadType.create([
    {name: "Rye Sour Loaf", sour_dough: true, notes: "Tates great!"},
    {name: "Chabata", sour_dough: false, notes: "I doubt it is spelt like this"}
  ])
end

unless (EmailTemplate.find_by name: 'new_sub' )
  new_sub = EmailTemplate.create({name: "new_sub", body: "Welcome {{subscriber.name}}!
  Let us know if your details are incorrect: phone {{subscriber.phone}}, address: {{subscriber.address}}
  You will be getting your bread {{bread_type}} from {{collection_point.name}}, {{collection_point.address}}, {{collection_point.post_code}} on {{subscriber.day_of_week}} starting on {{subscriber.start_date}}".gsub(/^\s*/,'')}
  )
end

unless (EmailTemplate.find_by name: 'stripe_invoice' )
  stripe_invoice = EmailTemplate.create({name: 'stripe_invoice', body: "Hi {{subscriber.name}},
                                         on {{invoice.next_payment_attempt}} you will be charged £{{invoice.total}} for your {{bread_type}}.
                                         This covers you untill {{invoice.period_end}}.
                                         Thanks!".gsub(/^\s*/,'')})
end
unless (EmailTemplate.find_by name: 'sub_deleted' )
  stripe_invoice = EmailTemplate.create({name: 'sub_deleted', body: "Hi {{subscriber.name}},
                                         Sorry to hear you are leaving.  We hoped you liked your {{bread_type}}.  If this is unexpected then maybe there
                                         has been some issues with your card - please email or call us.
                                         Thanks!".gsub(/^\s*/,'')})
end
