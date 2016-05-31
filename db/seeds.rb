# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Role.create [{name: :admin},{name: :support}]

puts "Virtual Domains"

list_domain=[['gadz.org', '1'],
['m4am.net', '2'],
['aix.gadz.org', '3'],
['an209.gadz.org', '4'],
['angers.gadz.org', '5'],
['asso.gadz.org', '6'],
['bo209.gadz.org', '7'],
['ch209.gadz.org', '8'],
['cl209.gadz.org', '9'],
['clunny.gadz.org', '10'],
['cluny.gadz.org', '11'],
['fontans.gadz.org', '12'],
['ka209.gadz.org', '13'],
['kanak.gadz.org', '14'],
['kin209.gadz.org', '15'],
['li209.gadz.org', '16'],
['me209.gadz.org', '17'],
['proms.gadz.org', '18'],
['ueensam.org', '19'],
['gadzarts.org', '1'],
['m4.am', '21'],
['sibers.gadz.org', '22'],
['li209.gadz.org', '23'],
['cg49.gadz.org', '24'],
['lille.gadz.org', '24'],
['ampedia.fr', '26'],
['canada.gadz.org', '27'],
['cg67.gadz.org', '28'],
['savoie.gadz.org', '28'],
['cg163.gadz.org', '30'],
['mantesmeulan.gadz.org', '30'],
['aix.gadz.org', '34'],
['aufeminin.gadz.org', '35'],
['ec.gadz.org', '36'],
['aumons.gadz.org', '37'],
['li204.gadz.org', '38'],
['ueensam.org', '41'],
['arts-et-metiers.asso.fr', '42'],
['me208.gadz.org', '45'],
['me204.gadz.org', '46'],
['cg63.gadz.org', '48'],
['lyon.gadz.org', '48'],
['me206.gadz.org', '50'],
['li203.gadz.org', '51'],
['cg20.gadz.org', '52'],
['drome-ardeche.gadz.org', '52'],
['dromeardeche.gadz.org', '52'],
['chalons.grand-gala.org', '57'],
['grand-gala.org', '58'],
['agoram.net', '59'],
['bordeaux.grand-gala.org', '60'],
['angers.grand-gala.org', '61'],
['cl204.gadz.org', '63'],
['kin208.gadz.org', '64'],
['bo209.gadz.org', '65'],
['am-tv.fr', '66'],
['znix.gadz.org', '68'],
['bordeaux.gadz.org', '69']]

list_domain.each do |d|
  a=EmailVirtualDomain.create(
    :name => d[0],
    :aliasing => d[1]
    )
  a.save
end