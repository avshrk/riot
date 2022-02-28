# Riot

## Usage

Set `RIOT_API_KEY` env variable to your API key.

To track a summoner and his/her coplayers:
```elixir
summoner_name |> Riot.track_summoners(region)
```

## Assumptions
* Application tracks both the given summoner and the coplayers.

## Todo
* Test coverage for error cases.

