defmodule FacebookMarketex.Get do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://graph.facebook.com"
  plug Tesla.Middleware.JSON

  adapter Tesla.Adapter.Hackney

  def long_lived_token(access_token, app_id, app_secret) do
    get("/v2.11/oauth/access_token", query: [grant_type: "fb_exchange_token", client_id: app_id, client_secret: app_secret, fb_exchange_token: access_token]).body
  end

  def me(access_token) do
    get("/v2.11/me", query: [access_token: access_token]).body
  end

  def ad_accounts(access_token, fields \\ []) do
    get("/v2.11/me/adaccounts", query: [access_token: access_token, fields: Enum.join(fields, ",")]).body
  end

  def data(access_token, id, fields) do
    get("/v2.11/" <> id, query: [access_token: access_token, fields: Enum.join(fields, ",")]).body
  end

  def campaigns(access_token, account_id, fields \\ [], limit \\ "") do
    get("/v2.11/" <> account_id <> "/campaigns", query: [access_token: access_token, fields: Enum.join(fields, ","), limit: limit]).body
  end

  def adsets(access_token, campaign_id, fields \\ [], limit \\ "") do
    get("/v2.11/" <> campaign_id <> "/adsets", query: [access_token: access_token, fields: Enum.join(fields, ","), limit: limit]).body
  end

  def ads(access_token, parent_id, fields \\ [], limit \\ "") do
    get("/v2.11/" <> parent_id <> "/ads", query: [access_token: access_token, fields: Enum.join(fields, ","), limit: limit]).body
  end

  def insights(access_token, id, fields, from, to, level \\ "", breakdowns \\ [], summary \\ true) do
    get("/v2.11/" <> id <> "/insights",
        query: [
          access_token: access_token,
          fields: Enum.join(fields, ","),
          time_range: Poison.encode!(%{"since": from, "until": to}),
          breakdowns: breakdowns,
          level: level,
          default_summary: summary,
          use_account_attribution_setting: true
        ]
    ).body
  end
end
