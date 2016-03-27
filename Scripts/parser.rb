require "sqlite3"

db = SQLite3::Database.new "cmudict.db"

db.execute("DROP TABLE IF EXISTS words;")
db.execute("CREATE TABLE words (word TEXT UNIQUE, syllable_count TINYINT);")
db.execute("CREATE INDEX WordIndex ON words(word);")

File.foreach("../cmudict.dict") do |line|
    
    # Ignore:
    # - 's and s' forms
    # - (N) variants
    # - single full-stop abbreviations
    if line =~ /\'s?\s/ or line =~ /\(\d\)/ or line =~ /^[^\.]*\.\s/
        puts "Ignoring #{line}"
    else
        word = line[/\S*(?=\s)/]
        syllable_count = line.scan(/\d/).count
    
        db.execute("INSERT INTO words (word, syllable_count) VALUES (?, ?)", [word, syllable_count])
    end
end

db.execute("VACUUM words")
