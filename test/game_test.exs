defmodule Riot.GameTest do
  use ExUnit.Case
  import ExUnit.CaptureLog
  import Mox

  alias Riot.Game

  setup :verify_on_exit!

  test "initialize player last match ids" do
    ["match_id"] |> http_poison_mock()

    assert [%{last_match_id: "match_id", name: "first", puuid: "puuid-1"}] ==
             [%{name: "first", puuid: "puuid-1", last_match_id: nil}]
             |> Game.initialize_last_match_ids("region")
  end

  test "prints to console if new match played" do
    ["12345678"] |> http_poison_mock()

    log =
      capture_log(
        [level: :info],
        # :stdio,
        fn ->
          result =
            [%{name: "first", puuid: "puuid-1", last_match_id: nil}]
            |> Game.check_for_new_matches("region")

          result
        end
      )

    assert true == String.contains?(log, "Summoner first completed match 12345678")
  end

  test "updates if new match played" do
    ["12345678"] |> http_poison_mock()

    assert [%{last_match_id: "12345678", name: "first", puuid: "puuid-1"}] ==
             [%{name: "first", puuid: "puuid-1", last_match_id: nil}]
             |> Game.check_for_new_matches("region")
  end

  defp http_poison_mock(body) do
    HTTPoisonMock
    |> expect(:get, 1, fn _, _, _ ->
      {:ok, %{body: body |> Poison.encode!()}}
    end)
  end
end
