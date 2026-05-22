module HtmlTables

using DataFrames
using Tables
import DBInterface

export htmlTable, htmlTableForQuery, retrievePKtuplesForTable, executeInsert

# Common helper functions (stay exactly the same for all databases)
function getDbPath()
    dbpath = joinpath(ENV["htmltables_dbpath"])
    return dbpath
end

function htmlTableHeaders(SqlResult)
    function retrieveHeaderNames(sqlResult)
        headerNames = []
        for name in SqlResult.names
            push!(headerNames, string(name))
        end
        headerNames
    end
    headerNames = retrieveHeaderNames(SqlResult)
    htmlHeaderRow = "<tr>"
    for headerName in headerNames
        header = "<th>"*headerName*"</th>"
        htmlHeaderRow = htmlHeaderRow * header
    end
    result = htmlHeaderRow*"</tr>"
    return result
end

function htmlTableData(SqlResult)
    df = DataFrame(SqlResult)
    tbl = Tables.rowtable(df)
    result = ""
    for row in Tables.rows(tbl)
        htmlDataRow = "<tr>"
        for field in row
            htmlDataRow = htmlDataRow*"<td>"*string(field)*"</td>"
        end
        htmlDataRow = htmlDataRow*"</tr>"
        result = result * htmlDataRow
    end
    return result
end

# These functions will be filled by the specific adapters (the pattern from your 4 files)
function htmlTable end
function htmlTableForQuery end
function retrievePKtuplesForTable end
function executeInsert end

end  # module HtmlTables