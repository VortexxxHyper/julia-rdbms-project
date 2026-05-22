module HtmlTablesMySQL

import ..HtmlTables
using MySQL
using DBInterface

# Extend the public functions with correct MySQL implementation
function HtmlTables.htmlTable(tableName)
    conn = DBInterface.connect(MySQL.Connection, 
        "127.0.0.1", 
        "root", 
        "162ssmw"; 
        db = "searchlight_test"
    )

    SqlStatement = "SELECT * FROM `$tableName`"
    SqlResult = DBInterface.execute(conn, SqlStatement)

    headers = HtmlTables.htmlTableHeaders(SqlResult)
    data = HtmlTables.htmlTableData(SqlResult)

    DBInterface.close(conn)
    return "<table>" * headers * data * "</table>"
end

function HtmlTables.htmlTableForQuery(SqlStatement)
    conn = DBInterface.connect(MySQL.Connection, 
        "127.0.0.1", 
        "root", 
        "162ssmw";
        db = "searchlight_test"
    )
    
    SqlResult = DBInterface.execute(conn, SqlStatement)
    
    headers = HtmlTables.htmlTableHeaders(SqlResult)
    data = HtmlTables.htmlTableData(SqlResult)
    
    DBInterface.close(conn)
    return "<table>"*headers*data*"</table>"
end

# Placeholder for other functions
function HtmlTables.retrievePKtuplesForTable(tableName)
    error("retrievePKtuplesForTable not yet implemented in MySQL adapter")
end

function HtmlTables.executeInsert(SqlStatement)
    conn = DBInterface.connect(MySQL.Connection, 
        "127.0.0.1", 
        "root", 
        "162ssmw"; 
        db = "searchlight_test"
    )
    SqlResult = DBInterface.execute(conn, SqlStatement)
    DBInterface.close(conn)
    return SqlResult
end

end  # module HtmlTablesMySQL