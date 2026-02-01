# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create initial admin user if none exists
if User.count.zero?
  admin = User.create!(
    name: "Admin",
    email_address: "admin@example.com",
    password: "password123",
    role: "admin"
  )
  puts "Created admin user: #{admin.email_address} (password: password123)"
  puts "⚠️  Please change this password after first login!"
else
  puts "Users already exist, skipping seed."
end
