function "salesforce_create_lead" {
  description = "Create a new lead in Salesforce"
  input {
    text first_name? { description = "Lead's first name" }
    text last_name { description = "Lead's last name (required)" }
    text company { description = "Lead's company name (required)" }
    email email? { description = "Lead's email address" }
    text phone? { description = "Lead's phone number" }
    text title? { description = "Lead's job title" }
    text lead_source? { description = "Source of the lead (e.g. Web, Referral)" }
    json custom_fields? { description = "Additional Salesforce fields as key-value pairs" }
  }
  stack {
    var $params {
      value = {
        LastName: $input.last_name,
        Company: $input.company
      }
    }
    var.update $params { value = $params|set_ifnotnull:"FirstName":$input.first_name }
    var.update $params { value = $params|set_ifnotnull:"Email":$input.email }
    var.update $params { value = $params|set_ifnotnull:"Phone":$input.phone }
    var.update $params { value = $params|set_ifnotnull:"Title":$input.title }
    var.update $params { value = $params|set_ifnotnull:"LeadSource":$input.lead_source }

    // Merge any custom fields into params
    conditional {
      if ($input.custom_fields != null) {
        var $keys { value = $input.custom_fields|keys }
        foreach ($keys) {
          each as $key {
            var.update $params { value = $params|set:$key:($input.custom_fields|get:$key) }
          }
        }
      }
    }

    api.request {
      url = $env.SALESFORCE_INSTANCE_URL ~ "/services/data/v59.0/sobjects/Lead"
      method = "POST"
      headers = ["Authorization: Bearer " ~ $env.SALESFORCE_ACCESS_TOKEN, "Content-Type: application/json"]
      params = $params
      mock = {
        "creates lead successfully": { response: { status: 201, result: { id: "00Q5e000001abc123", success: true, errors: [] } } }
      }
    } as $api_result

    precondition ($api_result.response.status == 201) {
      error_type = "standard"
      error = "Salesforce API error: " ~ ($api_result.response.result|json_encode)
    }

    var $result { value = $api_result.response.result }
  }
  response = $result

  test "creates lead successfully" {
    input = { last_name: "Doe", company: "Acme Corp", email: "john@acme.com" }
    expect.to_not_be_null ($response.id)
    expect.to_be_true ($response.success)
  }
}