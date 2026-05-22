module HtmlTablesPostgreSQL

import ..HtmlTables
using LibPQ
using DBInterface

# Extend the public functions with PostgreSQL implementation
function HtmlTables.htmlTable(tableName)
    conn = LibPQ.Connection("host=127.0.0.1 user=postgres password=162ssmw dbname=searchlight_test")
    SqlStatement = "SELECT * FROM $tableName"
    SqlResult = DBInterface.execute(conn, SqlStatement)
    headers = HtmlTables.htmlTableHeaders(SqlResult)
    data = HtmlTables.htmlTableData(SqlResult)
    close(conn)
    return "<table>"*headers*data*"</table>"
end

function HtmlTables.htmlTableForQuery(SqlStatement)
    conn = LibPQ.Connection("host=127.0.0.1 user=postgres password=162ssmw dbname=searchlight_test")
    SqlResult = DBInterface.execute(conn, SqlStatement)
    headers = HtmlTables.htmlTableHeaders(SqlResult)
    data = HtmlTables.htmlTableData(SqlResult)
    close(conn)
    return "<table>"*headers*data*"</table>"
end

# Placeholder for the other functions
function HtmlTables.retrievePKtuplesForTable(tableName)
    error("retrievePKtuplesForTable not yet implemented in PostgreSQL adapter")
end

function HtmlTables.executeInsert(SqlStatement)
    conn = LibPQ.Connection("host=127.0.0.1 user=postgres password=162ssmw dbname=searchlight_test")
    SqlResult = DBInterface.execute(conn, SqlStatement)
    close(conn)
    return SqlResult
end

end  # module HtmlTablesPostgreSQL