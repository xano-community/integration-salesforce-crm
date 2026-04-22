# Salesforce Integration for Xano

Create leads and query records in Salesforce CRM directly from your Xano workflows.

This integration also provisions 1 database table (see `tables/`).

## Functions

| Function | Description |
| --- | --- |
| `salesforce_create_lead` | Creates a new lead record in Salesforce. |
| `salesforce_query` | Executes a SOQL query against your Salesforce data. |

## Install

### Option A — Ask Claude Code

With the [Xano MCP](https://github.com/xano-labs/mcp-server) enabled in Claude Code, paste this into Claude:

> Install the integration at https://github.com/xano-community/integration-salesforce-crm into my Xano workspace.

Claude will clone the repo and push the functions and tables to your workspace.

### Option B — Use the Xano CLI

1. Install and authenticate the [Xano CLI](https://docs.xano.com/cli):
   ```sh
   npm install -g @xano/cli
   xano auth
   ```

2. Clone and push this integration:
   ```sh
   git clone https://github.com/xano-community/integration-salesforce-crm.git
   cd integration-salesforce-crm
   xano workspace:push . -w <your-workspace-id>
   ```

   Replace `<your-workspace-id>` with the ID from `xano workspace:list`.

## Configure Credentials

1. Log in to your Salesforce account and navigate to Setup.
2. Create a Connected App under App Manager with OAuth 2.0 enabled.
3. Complete the OAuth flow to obtain an access token and note your instance URL (e.g., https://yourinstance.salesforce.com).
4. In your Xano workspace, set the environment variable SALESFORCE_ACCESS_TOKEN to your OAuth access token.
5. Set the environment variable SALESFORCE_INSTANCE_URL to your Salesforce instance URL.

Environment variables used by this integration:

- `SALESFORCE_ACCESS_TOKEN`
- `SALESFORCE_INSTANCE_URL`

See `.env.example` for a template.

## Usage

Call any function from another function, task, or API endpoint using `function.run`:

```xs
function.run "salesforce_create_lead" {
  input = {
    // See function signature for required parameters
  }
} as $result
```

## Function Reference

### `salesforce_create_lead`

Creates a lead in Salesforce with fields such as first name, last name, email, company, and phone. Returns the new lead's ID on success. Use this to automatically push inbound leads from your app's signup forms or landing pages into your Salesforce CRM pipeline.

### `salesforce_query`

Runs a Salesforce Object Query Language (SOQL) query and returns matching records. Accepts any valid SOQL string, allowing you to search across any standard or custom object. Ideal for pulling CRM data into your Xano backend for reporting, syncing, or powering application features.

## License

MIT — see [LICENSE](./LICENSE).
