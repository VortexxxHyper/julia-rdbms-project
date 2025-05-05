using CSV, DataFrames, MySQL, Dates, DBInterface

# Delete the database 'imdb' and create it again so all data is dropped.
conn = DBInterface.connect(MySQL.Connection, "127.0.0.1", "root", "162ssmw")
DBInterface.execute(conn, "DROP DATABASE IF EXISTS imdb")
DBInterface.execute(conn, "CREATE DATABASE imdb")

println("Starting IMDb TSV import into MySQL...")
start_time = now()

# Load the TSV file into a DataFrame
df = CSV.read("name.basics.clean.tsv", DataFrame; delim='\t')

# Convert "NULL" strings in integer columns to missing
df.birthYear = replace(df.birthYear, "NULL" => missing)
df.deathYear = replace(df.deathYear, "NULL" => missing)

# Connect to MySQL using DBInterface.connect
DBInterface.execute(conn, "USE imdb")

# Create table schema (drop if exists for repeatability)
println("Creating table...")
@time begin
    DBInterface.execute(conn, "DROP TABLE IF EXISTS name_basics")
    DBInterface.execute(conn, """
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

println("Inserting data into MySQL...")
@time begin
    DBInterface.execute(conn, "START TRANSACTION")
    
    # Prepare the SQL statement
    stmt = DBInterface.prepare(conn, """
        INSERT INTO name_basics (nconst, primaryName, birthYear, deathYear, primaryProfession, knownForTitles)
        VALUES (?, ?, ?, ?, ?, ?)
    """)
    
    for row in eachrow(df)
        # Execute the prepared statement with the row data
        DBInterface.execute(stmt, (row.nconst, row.primaryName, row.birthYear, row.deathYear, row.primaryProfession, row.knownForTitles))
    end
    
    DBInterface.execute(conn, "COMMIT")
end


# Add indexes for performance
println("Adding indexes...")
@time DBInterface.execute(conn, "CREATE INDEX idx_primaryProfession ON name_basics(primaryProfession)")
@time DBInterface.execute(conn, "CREATE INDEX idx_knownForTitles ON name_basics(knownForTitles)")

# Close connection
DBInterface.close(conn)

# Print success message
println("Data successfully loaded into MySQL. Total time elapsed: ", now() - start_time)
