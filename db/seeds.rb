Bookmark.destroy_all

user = User.find_by(email: 'douglasmberkley@gmail.com')
user = User.create!(email: 'douglasmberkley@gmail.com', password: ENV['ADMIN_PASSWORD']) unless user
bookmark = Bookmark.create!(url: 'http://www.google.com', name: 'Google', user: User)
