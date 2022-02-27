defmodule Riot.Match do
  @moduledoc """
  Match Context
  """

  alias Riot.Request

  def get_last_matches_by_puuid(puuid, region) do
    :matches_by_puuid
    |> Request.make(puuid, region)
  end

  def get_last_match_by_puuid(puuid, region) do
    :match_by_puuid
    |> Request.make(puuid, region)
    |> List.first()
  end

  def get_by_match_id(match_id, region) do
    :match_by_match_id
    |> Request.make(match_id, region)
  end

  def get_puuids_by_match_id(match_id, region) do
    match_id
    |> get_by_match_id(region)
    |> get_participants()
  end

  def get_puuids_by_match_ids(match_ids, region) do
    match_ids
    |> Enum.map(&get_puuids_by_match_id(&1, region))
    |> List.flatten()
    |> Enum.uniq()
  end

  defp get_participants(%{"metadata" => %{"participants" => participants}}), do: participants
end
