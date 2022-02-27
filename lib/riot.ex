defmodule Riot do
  @moduledoc """
  Riot API
  """
  alias Riot.Game

  @spec track_summoners(String.t(), String.t()) :: list()
  defdelegate track_summoners(name, region), to: Game
end
