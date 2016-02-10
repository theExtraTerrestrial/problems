# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
unless Company.nil?
  10.times do |n|
    company = ('A'..'Z').to_a.shuffle[0,8].join
    name = 'Test'
    surname = "Dummy-#{n}"
    email = "test#{n}@example.org"
    password = 'password'
    Company.create!(name: company).create_user!(
      name: name,
      surname: surname,
      email: email,
      password: password)
    Role.user=User.where(:user_id, n)
  end
end
