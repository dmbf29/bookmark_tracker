puts "Removing bookmarks..."
Bookmark.destroy_all

puts 'Creating users...'
user = User.find_by(email: 'douglasmberkley@gmail.com')
user = User.create!(email: 'douglasmberkley@gmail.com', password: ENV['ADMIN_PASSWORD']) unless user
bookmark = Bookmark.create!(
  url: 'http://www.espnfc.com',
  name: 'ESPNFC',
  user: user,
  bookmark_tags_attributes: [
    { tag_attributes: { name: 'sports' } }
  ]
)
puts "...created #{Bookmark.count} bookmarks"
