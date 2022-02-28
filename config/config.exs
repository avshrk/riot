use Mix.Config

config :riot,
  mix_env: Mix.env(),
  riot_api_key: System.get_env("RIOT_API_KEY"),
  riot_api_subdomain: "api.riotgames.com",
  regions: %{
    "na" => "americas",
    "br" => "americas",
    "la" => "americas",
    "oc" => "americas",
    "kr" => "asia",
    "jp" => "asia",
    "eu" => "europe",
    "tr" => "europe",
    "ru" => "europe"
  }

import_config "#{Mix.env()}.exs"
