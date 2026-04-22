table "salesforce_data" {
  auth = false
  schema {
    int id
    int user_id { table = "user", description = "Reference to local user" }
    text instance_url { description = "Salesforce instance URL" }
    text access_token { description = "OAuth2 access token", sensitive = true }
    text refresh_token? { description = "OAuth2 refresh token", sensitive = true }
    timestamp token_expires_at? { description = "When the access token expires" }
    timestamp created_at?=now
  }
  index = [
    {type: "primary", field: [{name: "id"}]}
    {type: "btree|unique", field: [{name: "user_id"}]}
  ]
}