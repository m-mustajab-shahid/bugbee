puts "Seeding Admin User"

User.create(full_name: "Muhammad Mustajab Shahid", email: "mustajab@bugbee.com", password: 123456789, roles: 'admin')
