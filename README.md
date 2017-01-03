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

## Instructions and Demo
 Database *must* be pre-defined as `DBConnection,` including appropriate
 table and column-names, and required by SQLObject.  See [this example db ](https://github.com/mikeroess/rORM/blob/master/lib/db_connection.rb) for examples.  

 Any class inheriting from `SQLObject` will respond to:
 `all`, `new`, `find`, and `where` method calls with the results of an appropriate
 database query.  `find` takes an ID parameter; `all` and `where` take a hash of symbols (column names) and values.  

Instances of classes inheriting from `SQLObject` respond to `save` method and will be inserted or updated in database
as appropriate.  

Associations are defined with `belongs_to`, `has_many`, and `has_one_through`
methods invoked in class definition.  Through associations one can query the associated class's table for related records.  Association methods take the name of the method to be defined (symbol of associated class's table), and a hash requiring :class_name, :foreign_key, and :primary_key keys.  

Please see [demo.rb](https://github.com/mikeroess/rORM/blob/master/demo.rb) for examples of this code in action.  An example database has been supplied for this demo, which can be run in your favorite ruby repl.
