defmodule FacebookMarketex.Api do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://graph.facebook.com"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [access_token: System.get_env("FACEBOOK_ACCESS_TOKEN")]

  adapter Tesla.Adapter.Hackney

  def ad_accounts(fields \\ []) do
    get("/v2.10/me/adaccounts", query: [fields: Enum.join(fields, ",")]).body
    |> Map.get("data")
  end

  def get_data(id, fields) do
    get("/v2.10/" <> id, query: [fields: Enum.join(fields, ",")]).body
  end

  def get_name(id) do
    get_data(id, ["name"])
    |> Map.get("name")
  end

  def get_campaigns(account_id, fields \\ []) do
    get("/v2.10/" <> account_id <> "/campaigns", query: [fields: Enum.join(fields, ",")]).body
    |> Map.get("data")
  end

  def get_insights(id, fields, from, to, level \\ "", breakdowns \\ []) do
    get("/v2.10/" <> id <> "/insights",
        query: [
          fields: Enum.join(fields, ","),
          time_range: Poison.encode!(%{"since": from, "until": to}),
          breakdowns: breakdowns,
          level: level,
          use_account_attribution_setting: true
        ]
    ).body
    |> Map.get("data")
  end
end
