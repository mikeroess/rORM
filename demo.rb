require_relative 'lib/sql_object.rb'

class Book < SQLObject
	belongs_to(
		:author,
		class_name: "Author",
		foreign_key: :author_id,
		primary_key: :id
	)

	has_one_through(:publisher, :author, :publisher)
end

class Author < SQLObject
	has_many(
		:books,
		class_name: "Book",
		foreign_key: :author_id,
		primary_key: :id
	)

	belongs_to(
		:publisher,
		class_name: "Publisher",
		foreign_key: :publisher_id,
		primary_key: :id
	)
end

class Publisher < SQLObject
	has_many(
		:authors,
		class_name: "Author",
		foreign_key: :publisher_id,
		primary_key: :id
	)
end

puts "initializing database"
p DBConnection.reset


puts ""
puts ""
puts ""
puts ""
puts "This demo is a simple demonstration of rORM's primary methods."
puts "It is built atop a simple sqlite3 database with tables for books, publishers, and authors."
puts "the books.sql file defines the database.  Please look there for questions about its structure."
puts "For questions about association implementaion, please open this file in a text editor to see the assigned associations."

puts ""
puts "below, you will see printed the method called, followed by its result."
puts "NB: save will return the ID of any new record entered into the DB."


puts ""
puts "Book.all:"
p Book.all

puts ""
puts "Book.find(2):"
p Book.find(2)

puts ""
puts "Book.where(title: 'Living Clojure'):"
p Book.where(title: 'Living Clojure')

puts ""
puts "Book.find(1).author:"
p Book.find(1).author

puts ""
puts "Author.find(3).books:"
p Author.find(3).books

puts ""
puts "Book.find(1).publisher:"
p Book.find(1).publisher

puts ""
puts "Book.new(title: 'Probabilistic Logics and Probabilistic Networks
', author_id: 1).save:"
p Book.new(title: 'Probabilistic Logics and Probabilistic Networks
', author_id: 1).save
