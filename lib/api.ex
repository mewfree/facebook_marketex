defmodule FacebookMarketex.Api do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://graph.facebook.com"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [access_token: System.get_env("FACEBOOK_ACCESS_TOKEN")]

  adapter Tesla.Adapter.Hackney

  # defp parse_data(result_body) do
    # Map.get(result_body, "data")
  # end

  def ad_accounts() do
    get("/v2.10/me/adaccounts").body
    |> Map.get("data")
  end

  def get_account_data(account_id, fields) do
    get("/v2.10/" <> account_id, query: [fields: Enum.join(fields, ",")]).body
  end

  def get_account_name(account_id) do
    get_account_data(account_id, ["name"])
    |> Map.get("name")
  end

  def get_campaigns(account_id) do
    get("/v2.10/" <> account_id <> "/campaigns").body
    |> Map.get("data")
  end

  def get_campaign_data(campaign_id, fields) do
    get("/v2.10/" <> campaign_id, query: [fields: Enum.join(fields, ",")]).body
  end

  def get_campaign_insights(campaign_id, fields, from, to, breakdowns \\ []) do
    get("/v2.10/" <> campaign_id <> "/insights",
        query: [
          fields: Enum.join(fields, ","),
          time_range: Poison.encode!(%{"since": from, "until": to}),
          breakdowns: breakdowns,
          level: "adset",
          use_account_attribution_setting: true
        ]
    ).body
    |> Map.get("data")
  end
end
