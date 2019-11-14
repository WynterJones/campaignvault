user = User.new
user.email = 'demo@campaignvault.com'
user.password = 'campaignvault'
user.password_confirmation = 'campaignvault'
user.save!

puts "Saved User"

# require 'faker'
#
# 2000.times do
#   Request.create(
#     body: "{\"cannabis\": \"#{Faker::Cannabis.strain}\", \"game\": \"#{Faker::Game.title}\", \"movie quote\": \"#{Faker::Movie.quote}\", \"name\": \"#{Faker::FunnyName.name}\"}",
#     webhook_id: 4,
#     created_at: Faker::Date.between(from: 11.months.ago, to: Date.today)
#   )
# end
#
# puts "Added Fake Request Data"
