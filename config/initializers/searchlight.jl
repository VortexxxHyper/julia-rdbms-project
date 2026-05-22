using SearchLight

# Load the database configuration from the active connection_*.yml file
SearchLight.Configuration.load()

# If a database adapter is configured, set it up and connect
if SearchLight.config.db_config_settings["adapter"] !== nothing
    SearchLight.Database.setup_adapter()
    SearchLight.Database.connect()
    SearchLight.load_resources()
    @info "SearchLight connected to $(SearchLight.config.db_config_settings["adapter"]) database"
end