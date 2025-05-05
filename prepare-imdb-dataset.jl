using CSV
using DataFrames

# Step 1: Load the raw data
input_file = "name.basics.tsv"
println("Loading data from '$input_file'...")

# Replace \N with "NULL" while reading
df = CSV.read(input_file, DataFrame; delim='\t', missingstring="\\N")

# Step 2: Replace Julia `missing` with string "NULL" for SQL compatibility
function replace_missing_with_null!(df::DataFrame)
    for col in names(df)
        # Replace `missing` with the string "NULL"
        df[!, col] = coalesce.(df[!, col], "NULL")
    end
    
end

replace_missing_with_null!(df)
println("Replaced all missing values with 'NULL'.")

# Step 3: Save to new file
output_file = "name.basics.clean.tsv"
CSV.write(output_file, df; delim="\t")
println("Cleaned data saved to '$output_file'. Ready for SQL import.")
