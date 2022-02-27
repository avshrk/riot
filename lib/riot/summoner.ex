defmodule Riot.Summoner do
  @moduledoc """
  Summoner Context
  """

  alias Riot.Request
  alias __MODULE__

  @type t :: %__MODULE__{}

  defstruct name: nil, puuid: nil, last_match_id: nil

  def get_by_name(name, region) do
    :summoner_by_name
    |> Request.make(name, region)
  end

  def get_by_puuid(puuid, region) do
    :summoner_by_puuid
    |> Request.make(puuid, region)
  end

  def get_name_by_puuid(puuid, region) do
    name =
      puuid
      |> get_by_puuid(region)
      |> get_name()

    %Summoner{name: name, puuid: puuid, last_match_id: nil}
  end

  def get_names_by_puuids(puuids, region) do
    puuids
    |> Enum.map(&get_name_by_puuid(&1, region))
  end

  defp get_name(%{"name" => name}), do: name
end
