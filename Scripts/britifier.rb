require "sqlite3"
require "highline/import"

db = SQLite3::Database.new "cmudict.db"

likes = ["%ize", "%ized", "%izing", "%izes", "%yze", "%yzed", "%yzing", "%yzes"]
subquery = likes.map { |like| "word LIKE '#{like}'"}.join(" OR ")

db.execute("SELECT word, syllable_count FROM words WHERE #{subquery}") do |entry|
    syllable_count = entry[1]
    ize_form = entry[0]
    ise_form = ize_form.sub "ize", 'ise'
    ise_form = ise_form.sub "yze", 'yse'
    ise_form = ise_form.sub "izi", "isi"
    ise_form = ise_form.sub "yzi", "ysi"
    
    existing_entry = db.execute("SELECT word FROM words WHERE word='#{ise_form}'")
    if existing_entry.count == 0 && HighLine.agree("\"#{ise_form}\": (for \"#{ize_form}\") not found. Create? (y/n)")
        db.execute("INSERT INTO words (word, syllable_count) VALUES (?, ?)", [ise_form, syllable_count])
    end
end

db.execute("VACUUM words")
