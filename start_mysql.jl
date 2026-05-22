using Genie


ENV["GENIE_DB_CONFIG"] = joinpath(pwd(), "config", "db", "connection_mysql.yml")  
# ← change to connection_postgresql.yml or connection_sqlite.yml when you switch


println("========================================")
println("GENIE + SEARCHLIGHT IS RUNNING!")
println("Open this address in your browser → http://localhost:8000")
println("or → http://127.0.0.1:8000")
println("========================================")


Genie.up(
    host = "0.0.0.0",
    port = 8000,
    async = false
)


sleep(Inf)   # keeps the server running until you stop it with Ctrl+C