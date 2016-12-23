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

puts "Book.all"
p Book.all

puts "Book.find(2)"
p Book.find(2)

puts "Book.where(title: 'Living Clojure')"
p Book.where(title: 'Living Clojure')

puts "Book.find(1).author"
p Book.find(1).author

puts "Author.find(4).books"
p Author.find(3).books

puts "Book.find(1).publisher"
p Book.find(1).publisher

puts "Book.new(title: 'Probabilistic Logics and Probabilistic Networks
', author_id: 4).save"
p Book.new(title: 'Probabilistic Logics and Probabilistic Networks
', author_id: 1).save
