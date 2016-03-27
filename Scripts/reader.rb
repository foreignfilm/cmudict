require "sqlite3"

db = SQLite3::Database.new "cmudict.db"

db.execute("SELECT * FROM words WHERE word='articulation'" ) do |row|
    puts row
end
