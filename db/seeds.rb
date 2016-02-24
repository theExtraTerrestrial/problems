# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password', role_id: 1, first_name: 'Super', last_name: 'Admin')
AdminUser.create!(email: 'darbinieks@example.com', password: 'password', password_confirmation: 'password', role_id: 2, first_name: 'Parasts', last_name: 'Mirstīgais')
Role.create!(name: 'Admin')
Role.create!(name: 'Darbinieks')
Category.create!(name: 'Sūdzība')
Company.create!(name: 'Google')