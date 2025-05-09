using CSV, DataFrames

input_file = "name.basics.tsv"
println("Loading data from '$input_file'...")

df = CSV.read(input_file, DataFrame; delim='\t', missingstring="\\N")

function replace_missing_with_null!(df::DataFrame)
    for col in names(df)
        df[!, col] = coalesce.(df[!, col], "NULL")
    end
    
end

replace_missing_with_null!(df)
println("Replaced all missing values with 'NULL'.")

output_file = "name.basics.clean.tsv"
CSV.write(output_file, df; delim="\t")
println("Cleaned data saved to '$output_file'. Ready for SQL import.")
