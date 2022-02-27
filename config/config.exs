use Mix.Config

config :riot,
  mix_env: Mix.env(),
  riot_api_key: "RGAPI-1cf1b953-abf9-4457-8d65-be9724a56ff3",
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
