defmodule FacebookMarketex.Create do
  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://graph.facebook.com"
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.Query, [access_token: System.get_env("FACEBOOK_ACCESS_TOKEN")]

  adapter Tesla.Adapter.Hackney

  def campaign(account_id, name, objective, status \\ "PAUSED") do
    query_data = %{
      "name" => name,
      "objective" => objective,
      "status" => status
    }

    post("/v2.10/" <> account_id <> "/campaigns", query_data).body
    |> Poison.decode!
  end
end
