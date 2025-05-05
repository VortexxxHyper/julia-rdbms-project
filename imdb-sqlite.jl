using CSV, DataFrames, SQLite, Dates

println("Starting IMDb TSV import into SQLite...")
start_time = now()

# Load the TSV file into a DataFrame
df = CSV.read("name.basics.clean.tsv", DataFrame; delim='\t')

# Create SQLite database
db = SQLite.DB("imdb-sqlite.db")

# Create table schema (drop if exists for repeatability)
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

# Insert data into SQLite
println("Inserting data into SQLite...")
@time SQLite.load!(df, db, "name_basics"; ifnotexists=false)

# Add indexes for performance
println("Adding indexes...")
@time SQLite.execute(db, "CREATE INDEX idx_primaryProfession ON name_basics(primaryProfession);")
@time SQLite.execute(db, "CREATE INDEX idx_knownForTitles ON name_basics(knownForTitles);")

# Close DB
SQLite.close(db)

# Print success message
println("Data successfully loaded into SQLite. Total time elasped: ", now() - start_time)
