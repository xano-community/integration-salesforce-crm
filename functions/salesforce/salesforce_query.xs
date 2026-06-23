function "salesforce_query" {
  description = "Execute a SOQL query against Salesforce"
  input {
    text query { description = "SOQL query string (e.g. SELECT Id, Name FROM Lead WHERE Email = 'test@example.com')" }
  }
  stack {
    api.request {
      url = $env.SALESFORCE_INSTANCE_URL ~ "/services/data/v59.0/query"
      method = "GET"
      headers = ["Authorization: Bearer " ~ $env.SALESFORCE_ACCESS_TOKEN]
      params = { q: $input.query }
      mock = {
        "executes SOQL query": { response: { status: 200, result: { totalSize: 1, done: true, records: [{ Id: "00Q5e000001abc123", Name: "John Doe", Company: "Acme Corp" }] } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 200) {
      error_type = "standard"
      error = "Salesforce API error: " ~ ($api_result.response.result|json_encode)
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "executes SOQL query" {
    input = { query: "SELECT Id, Name FROM Lead LIMIT 1" }
    expect.to_equal ($response.totalSize) { value = 1 }
    expect.to_be_true ($response.done)
    expect.to_not_be_null ($response.records)
  }
}