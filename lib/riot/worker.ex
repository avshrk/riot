defmodule Riot.Worker do
  @moduledoc """
  Worker Context ( Server/Client )
  """
  use GenServer, restart: :temporary

  alias Riot.Game

  @type t :: %__MODULE__{}

  defstruct players: [], minute: 0, region: nil

  @minute 60_000
  @hour 60

  ################################################################################
  # Client
  ################################################################################

  def start_link(summoner_work) do
    GenServer.start_link(__MODULE__, summoner_work)
  end

  ################################################################################
  # Server
  ################################################################################

  @impl true
  def init(summoner_work) do
    {:ok, summoner_work, {:continue, nil}}
  end

  @impl true
  def handle_continue(nil, %{players: players, region: region} = summoner_work) do
    players = players |> Game.initialize_last_match_ids(region)
    %{summoner_work | players: players} |> continue_or_stop()
  end

  @impl true
  def handle_info(
        :fetch_last_match,
        %{players: players, minute: minute, region: region} = summoner_work
      ) do
    players = players |> Game.check_for_new_matches(region)
    %{summoner_work | minute: minute + 1, players: players} |> continue_or_stop()
  end

  ################################################################################
  # Helpers
  ################################################################################

  defp continue_or_stop(%{minute: minute} = summoner_work) when @hour > minute do
    schedule_info_fetch()
    {:noreply, summoner_work}
  end

  defp continue_or_stop(summoner_work), do: {:stop, :normal, summoner_work}

  defp schedule_info_fetch do
    Process.send_after(self(), :fetch_last_match, @minute)
  end
end
