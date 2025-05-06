using CSV, DataFrames, SQLite, Dates

println("Starting IMDb TSV import into SQLite...")
start_time = now()

df = CSV.read("name.basics.clean.tsv", DataFrame; delim='\t')

db = SQLite.DB("imdb-sqlite.db")

println("Creating table...")
@time SQLite.execute(db, """
DROP TABLE IF EXISTS name_basics;
CREATE TABLE name_basics (
    nconst TEXT PRIMARY KEY,
    primaryName TEXT,
    birthYear INTEGER,
    deathYear INTEGER,
    primaryProfession TEXT,
    knownForTitles TEXT
);
""")

println("Inserting data into SQLite...")
@time SQLite.load!(df, db, "name_basics"; ifnotexists=false)

println("Adding indexes...")
@time SQLite.execute(db, "CREATE INDEX idx_primaryProfession ON name_basics(primaryProfession);")
@time SQLite.execute(db, "CREATE INDEX idx_knownForTitles ON name_basics(knownForTitles);")

SQLite.close(db)

println("Data successfully loaded into SQLite. Total time elasped: ", now() - start_time)