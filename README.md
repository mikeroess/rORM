# rORM
rORM is a simple, light weight implementation of Object Relational Mapping in Ruby.  Any class inheriting from rORM's SQLObject class is mapped onto an existing table in the supplied database (at present only tested with SQLite3). SQLObject's children can be connected through `belongs_to`, `has_many`, and `has_one_through` associations.  

## Features
* dynamically generate getting and setter methods for column names
* search for specific record by id with `.find`
* return all records in a table with `.all`
* filter search results with `.where`
  * `.where` accepts an options hash with column names as keys
* insert or update record with `.save`
* connect classes with `belongs_to`, `has_many`, and `has_one_through` methods

## Example Code
```
class Book < SQLObject
	belongs_to(
		:author,
		class_name: "Author",
		foreign_key: :author_id,
		primary_key: :id
	)

end

class Author < SQLObject
	has_many(
		:books,
		class_name: "Book",
		foreign_key: :author_id,
		primary_key: :id
	)
end

new_author = Author.new(fname: "Jim", lname: "Starlin")
new_author.save

new_book = Book.new(title: "The Death of Captain Marvel", author_id: new_author.id)
new_book.save

Book.all.last.author
```

## Demo
To see rORM's basic features in action `load 'demo.rb'` in your favorite Ruby repl (`pry` maybe?).
