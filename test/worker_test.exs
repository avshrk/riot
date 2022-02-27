defmodule Riot.WorkerTest do
  use ExUnit.Case

  import Mox

  alias Riot.Worker

  setup do
    set_mox_global()
    verify_on_exit!()

    p1 = %{name: "p1", puuid: "p1-puuid", last_match_id: nil}

    summoner_work1 = %{
      players: [p1],
      minute: 0,
      region: "r-1"
    }

    summoner_work2 = %{
      players: [p1],
      minute: 0,
      region: "r-1"
    }

    {:ok, summoner_work1: summoner_work1, summoner_work2: summoner_work2}
  end

  test "initializes by setting player's last match id", %{
    summoner_work1: summoner_work
  } do
    ["match_id"] |> http_poison_mock()

    pid = start_supervised!({Worker, summoner_work})

    assert %{
             minute: 0,
             players: [%{last_match_id: "match_id", name: "p1", puuid: "p1-puuid"}],
             region: "r-1"
           } ==
             :sys.get_state(pid)
  end

  test "updates players last match id", %{
    summoner_work2: summoner_work
  } do
    ["match_id"] |> http_poison_mock()

    pid = start_supervised!({Worker, summoner_work})

    ["12345678"] |> http_poison_mock()
    send(pid, :fetch_last_match)

    assert %{
             minute: 1,
             players: [%{last_match_id: "12345678", name: "p1", puuid: "p1-puuid"}],
             region: "r-1"
           } ==
             :sys.get_state(pid)
  end

  defp http_poison_mock(body) do
    HTTPoisonMock
    |> expect(:get, 1, fn _, _, _ ->
      {:ok, %{body: body |> Poison.encode!()}}
    end)
  end
end
