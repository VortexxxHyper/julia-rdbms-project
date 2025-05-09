using CSV, DataFrames, LibPQ, Dates

println("Starting IMDb TSV import into PostgreSQL...")
start_time = now()

df = CSV.read("name.basics.clean.tsv", DataFrame; delim='\t')

df.birthYear = replace(df.birthYear, "NULL" => missing)
df.deathYear = replace(df.deathYear, "NULL" => missing)

conn = LibPQ.Connection("dbname=imdb user=postgres password='162ssmw' host=localhost port=1620")

println("Creating table...")
@time begin
    LibPQ.execute(conn, "DROP TABLE IF EXISTS name_basics")
    LibPQ.execute(conn, """
        CREATE TABLE name_basics (
            nconst VARCHAR(10) PRIMARY KEY,
            primaryName VARCHAR(255),
            birthYear INTEGER,
            deathYear INTEGER,
            primaryProfession VARCHAR(255),
            knownForTitles VARCHAR(255)
        )
    """)
end

println("Inserting data into PostgreSQL...")
@time begin
    LibPQ.execute(conn, "BEGIN")
    LibPQ.load!(df, conn,
        "INSERT INTO name_basics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles)
         VALUES (\$1, \$2, \$3, \$4, \$5, \$6)"
    )
    LibPQ.execute(conn, "COMMIT")
end

println("Adding indexes...")
@time LibPQ.execute(conn, "CREATE INDEX idx_primaryProfession ON name_basics(primaryProfession)")
@time LibPQ.execute(conn, "CREATE INDEX idx_knownForTitles ON name_basics(knownForTitles)")

LibPQ.close(conn)

println("Data successfully loaded into PostgreSQL. Total time elasped: ", now() - start_time)
