defmodule FacebookMarketex.Delete do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://graph.facebook.com"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.Query, [access_token: System.get_env("FACEBOOK_ACCESS_TOKEN")]

  adapter Tesla.Adapter.Hackney

  def node(id) do
    delete("/v2.11/" <> id).body
  end
end
