defmodule Riot.Game do
  @moduledoc """
  Game Context
  """
  require Logger

  alias Riot.{
    Match,
    Summoner,
    Worker
  }

  @spec track_summoners(String.t(), String.t()) :: list()
  def track_summoners(name, region) do
    players = name |> get_coplayers(region)

    %Worker{players: players, region: region}
    |> start_worker()

    players |> player_names()
  end

  @spec initialize_last_match_ids(list(), String.t()) :: list()
  def initialize_last_match_ids(players, region) do
    players
    |> Enum.map(&add_last_match_id(&1, region))
  end

  @spec check_for_new_matches(list(), String.t()) :: list()
  def check_for_new_matches(players, region) do
    players
    |> Enum.map(fn p ->
      match_id = p.puuid |> Match.get_last_match_by_puuid(region)
      match_id |> log_if_new_match(p)
    end)
  end

  defp start_worker(summoner_work) do
    summoner_work |> Riot.Application.start_worker()
  end

  defp get_coplayers(name, region) do
    name
    |> Summoner.get_by_name(region)
    |> get_puuid()
    |> Match.get_last_matches_by_puuid(region)
    |> Match.get_puuids_by_match_ids(region)
    |> Summoner.get_names_by_puuids(region)
  end

  defp log_if_new_match(new_match_id, player) do
    new_match_id
    |> is_new_match(player)
    |> case do
      true ->
        player |> log_new_match(new_match_id)
        %{player | last_match_id: new_match_id}

      _ ->
        player
    end
  end

  defp add_last_match_id(%{puuid: puuid} = p, region) do
    last_match_id = Match.get_last_match_by_puuid(puuid, region)
    %{p | last_match_id: last_match_id}
  end

  defp log_new_match(%{name: name}, new_match_id) do
    "Summoner #{name} completed match #{new_match_id}"
    |> Logger.info()
  end

  defp is_new_match(last_match_id, %{last_match_id: existing_last_match_id}),
    do: last_match_id != existing_last_match_id

  defp is_new_match(_, _), do: false

  defp get_puuid(%{"puuid" => puuid}), do: puuid

  defp player_names(players) do
    players |> Enum.map(& &1.name)
  end
end
