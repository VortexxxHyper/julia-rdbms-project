try
  Genie.Util.isprecompiling() || Genie.Secrets.secret_token!("e6de4cd9e2e384b36af3d31650fb8002a4804ee6fbd95ddef03ed6def9561a3e")
catch ex
  @error "Failed to generate secrets file: $ex"
end
