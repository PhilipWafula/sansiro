# frozen_string_literal: true

# frozen_string_literal true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
admin = CreateAdminService.new.call
puts 'CREATED ADMIN USER:', admin.email

# 50.times do
# Tip.create(tip_content: Faker::Quotes::Shakespeare.hamlet,
# tip_package: %w[Jackpot Premium Regular].sample,
# tip_expiry: Faker::Time.between(5.months.ago, 5.months.from_now),
# tip_date: Faker::Date.between(5.months.ago, 5.months.from_now),
# admin_id: 1)
# end
# puts 'CREATE SAMPLE TIP DATA'
