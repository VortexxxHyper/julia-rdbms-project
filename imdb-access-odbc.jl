using CSV, DataFrames, ODBC, Dates

println("Starting IMDb TSV import into MS Access...")
start_time = now()

df = CSV.read("name.basics.clean.tsv", DataFrame; delim='\t')

df.birthYear = replace(df.birthYear, "NULL" => missing)
df.deathYear = replace(df.deathYear, "NULL" => missing)

const DSN_NAME = "imdb-access-odbc"

conn = ODBC.Connection(DSN_NAME)

println("Creating table...")
@time begin
    try
        DBInterface.execute(conn, "DROP TABLE name_basics")
    catch e
        println("Table did not exist, continuing...")
    end
    DBInterface.execute(conn, """
        CREATE TABLE name_basics (
            nconst TEXT(10) PRIMARY KEY,
            primaryName TEXT(255),
            birthYear INTEGER,
            deathYear INTEGER,
            primaryProfession TEXT(255),
            knownForTitles TEXT(255)
        )
    """)
end

println("Inserting data into MS Access...")

batch_size = 100
@time begin
    for i in 1:batch_size:size(df, 1)
        batch = df[i:min(i + batch_size - 1, size(df, 1)), :]
        sql = "INSERT INTO name_basics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles) VALUES "
        values = []
        
        for row in eachrow(batch)
            nconst = String(row.nconst)
            primaryName = String(row.primaryName)
            birthYear = isnothing(row.birthYear) || row.birthYear === missing ? "NULL" : string(parse(Int, String(row.birthYear)))
            deathYear = isnothing(row.deathYear) || row.deathYear === missing ? "NULL" : string(parse(Int, String(row.deathYear)))
            primaryProfession = String(row.primaryProfession)
            knownForTitles = String(row.knownForTitles)
            push!(values, "('$nconst', '$primaryName', $birthYear, $deathYear, '$primaryProfession', '$knownForTitles')")
        end
        sql *= join(values, ", ") * ";"

        # Execute the dynamic SQL query
        DBInterface.execute(conn, sql)

        # Commit after each batch of 100
        DBInterface.execute(conn, "COMMIT")
        
        println("Batch inserted and committed: Rows ", i, " to ", i + batch_size - 1)
    end
end

println("Adding indexes...")
@time DBInterface.execute(conn, "CREATE INDEX idx_primaryProfession ON name_basics(primaryProfession)")
@time DBInterface.execute(conn, "CREATE INDEX idx_knownForTitles ON name_basics(knownForTitles)")

finally
    DBInterface.close!(conn)
end

println("Data successfully loaded into MS Access. Total time elasped: ", now() - start_time)
