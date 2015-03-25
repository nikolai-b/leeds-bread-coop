unless (Subscriber.find_by email: 'Leeds Bread Co-op')
  Subscriber.create first_name: 'Leeds', last_name: 'Bread Co-op', email: 'info@leedsbread.coop', phone: '0113 262 5155', collection_point_id: 2, password: 'password', admin: true
end
unless (CollectionPoint.find_by name: 'Green Action')
  collection_points = CollectionPoint.create([
    {name: "Green Action", address: "LUU", post_code: 'LS2 ...', notes: "Nice students", valid_days: [3, 5]},
    {name: "LILAC", address: "Kirstall", post_code: 'LS? ...', notes: "Very eco", valid_days: [3, 5]}
  ])
end

def create_collection_point(name)
  unless (CollectionPoint.find_by name: name)
    CollectionPoint.create!( {name: name, valid_days: [3, 5] } )
  end
end

[
  "Wharf Chambers",
  "Greenhouse",
  "Fabrication",
  "Woodhouse",
  "Haley&Cliff",
  "Opposite",
  "Cafe 164"
].each {|c| create_collection_point(c) }


unless (BreadType.find_by name: 'White Sour' )
  BreadType.create( {name: "White Sourdough", sour_dough: true, notes: "Tates great!"} )
end

unless (BreadType.find_by name: 'Seedy Sourdough' )
  BreadType.create( {name: "Seedy Sourdough", sour_dough: true, notes: "Lots of seeds"} )
end

unless (BreadType.find_by name: 'Vollkornbrot (100% rye)' )
  BreadType.create( {name: 'Vollkornbrot (100% rye)', sour_dough: false, notes: "Not sure if this is sour or not"} )
end

unless (BreadType.find_by name: 'Weekly Special' )
  BreadType.create( {name: 'Weekly Special', sour_dough: false, notes: "Not sure if this is sour or not"} )
end

unless (EmailTemplate.find_by name: 'new_sub' )
  new_sub = EmailTemplate.create({name: "new_sub", body: "Welcome {{subscriber.first_name}}!
  Let us know if your details are incorrect: phone {{subscriber.phone}}, address: {{subscriber.address}}
  You will be getting your bread(s) {{bread_types}} from {{collection_point.name}}, {{collection_point.address}}, {{collection_point.post_code}} on
  {{subscriber.day_of_week}} starting on {{subscriber.collection_day_name}}, but we need three days to get an order started so if its closer than 3 days it will be next week.".gsub(/^\s*/,'')}
  )
end

unless (EmailTemplate.find_by name: 'stripe_invoice' )
  stripe_invoice = EmailTemplate.create({name: 'stripe_invoice', body: "Hi {{subscriber.first_name}},
                                         on {{invoice.next_payment_attempt}} you will be charged £{{invoice.total}} for your {{bread_type}}.
                                         This covers you untill {{invoice.period_end}}.
                                         Thanks!".gsub(/^\s*/,'')})
end
unless (EmailTemplate.find_by name: 'sub_deleted' )
  stripe_invoice = EmailTemplate.create({name: 'sub_deleted', body: "Hi {{subscriber.first_name}},
                                         Sorry to hear you are leaving.  We hoped you liked your {{bread_type}}.  If this is unexpected then maybe there
                                         has been some issues with your card - please email or call us.
                                         Thanks!".gsub(/^\s*/,'')})
end
