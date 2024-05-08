# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!(name: '鈴木', email: 'falao@sample.com',password: 'cpy5sp10',password_confirmation: 'cpy5sp10')
User.create!(name: '花子', email: 'hanako@sample.com',password: 'cpy5sp11',password_confirmation: 'cpy5sp11')
User.create!(name: '山田', email: 'yamada@sample.com',password: 'cpy5sp12',password_confirmation: 'cpy5sp12')
User.create!(name: '太郎', email: 'tarou@sample.com',password: 'cpy5sp13',password_confirmation: 'cpy5sp13')
User.create!(name: '佐藤', email: 'falao@sample.com',password: 'cpy5sp14',password_confirmation: 'cpy5sp14')
User.create!(name: '野村', email: 'nomu@sample.com',password: 'cpy5sp15',password_confirmation: 'cpy5sp15')
User.create!(name: '菊本', email: 'bosu@sample.com',password: 'cpy5sp16',password_confirmation: 'cpy5sp16')
User.create!(name: '中井', email: 'nakai@sample.com',password: 'cpy5sp17',password_confirmation: 'cpy5sp17')
