defmodule Riot.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: Riot.WorkSupervisor}
    ]

    opts = [strategy: :one_for_one, name: Riot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def start_worker(summoner_work) do
    DynamicSupervisor.start_child(Riot.WorkSupervisor, {Riot.Worker, summoner_work})
  end
end
