defmodule FacebookMarketex.Get do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://graph.facebook.com"
  plug Tesla.Middleware.JSON

  adapter Tesla.Adapter.Hackney

  def long_lived_token(access_token, app_id, app_secret) do
    get("/v2.10/oauth/access_token", query: [grant_type: "fb_exchange_token", client_id: app_id, client_secret: app_secret, fb_exchange_token: access_token]).body
  end

  def ad_accounts(access_token, fields \\ []) do
    get("/v2.10/me/adaccounts", query: [access_token: access_token, fields: Enum.join(fields, ",")]).body
    |> Map.get("data")
  end

  def data(access_token, id, fields) do
    get("/v2.10/" <> id, query: [access_token: access_token, fields: Enum.join(fields, ",")]).body
  end

  def campaigns(access_token, account_id, fields \\ []) do
    get("/v2.10/" <> account_id <> "/campaigns", query: [access_token: access_token, fields: Enum.join(fields, ",")]).body
    |> Map.get("data")
  end

  def insights(access_token, id, fields, from, to, level \\ "", breakdowns \\ []) do
    get("/v2.10/" <> id <> "/insights",
        query: [
          access_token: access_token,
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
