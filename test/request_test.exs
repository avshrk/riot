defmodule Riot.RequestTest do
  use ExUnit.Case

  import Mox

  alias Riot.Request

  setup :verify_on_exit!

  describe "make a request to get " do
    test "summoner by name" do
      %HTTPoison.Response{
        body:
          "{\"id\":\"cOS1MKXk8W060i4EwMcV9ghaY7JZMRgp0MwutraZNsaORw\",\"accountId\":\"Htj0PTEYbFf0iYnmwYJM-nMt0Nr1dvQ3DQxCRVA7aNPN\",\"puuid\":\"mIDavHdKADyvW3JhQ5tYH8hVmRnepjKonw9C5FjD8n5TyaBLAfVZaCxf2Z1RDrnPgboeDArSw5qrcQ\",\"name\":\"dontbeemotional2\",\"profileIconId\":6,\"revisionDate\":1645717981000,\"summonerLevel\":128}"
      }
      |> httposion_mock(1)

      assert %{
               "accountId" => "Htj0PTEYbFf0iYnmwYJM-nMt0Nr1dvQ3DQxCRVA7aNPN",
               "id" => "cOS1MKXk8W060i4EwMcV9ghaY7JZMRgp0MwutraZNsaORw",
               "name" => "dontbeemotional2",
               "profileIconId" => 6,
               "puuid" =>
                 "mIDavHdKADyvW3JhQ5tYH8hVmRnepjKonw9C5FjD8n5TyaBLAfVZaCxf2Z1RDrnPgboeDArSw5qrcQ",
               "revisionDate" => 1_645_717_981_000,
               "summonerLevel" => 128
             } == Request.make(:summoner_by_name, "dontbeemotional2", "br1")
    end

    test "summoner by puuid" do
      %HTTPoison.Response{
        body:
          "{\"id\":\"cOS1MKXk8W060i4EwMcV9ghaY7JZMRgp0MwutraZNsaORw\",\"accountId\":\"Htj0PTEYbFf0iYnmwYJM-nMt0Nr1dvQ3DQxCRVA7aNPN\",\"puuid\":\"mIDavHdKADyvW3JhQ5tYH8hVmRnepjKonw9C5FjD8n5TyaBLAfVZaCxf2Z1RDrnPgboeDArSw5qrcQ\",\"name\":\"dontbeemotional2\",\"profileIconId\":6,\"revisionDate\":1645717981000,\"summonerLevel\":128}"
      }
      |> httposion_mock(1)

      assert %{
               "accountId" => "Htj0PTEYbFf0iYnmwYJM-nMt0Nr1dvQ3DQxCRVA7aNPN",
               "id" => "cOS1MKXk8W060i4EwMcV9ghaY7JZMRgp0MwutraZNsaORw",
               "name" => "dontbeemotional2",
               "profileIconId" => 6,
               "puuid" =>
                 "mIDavHdKADyvW3JhQ5tYH8hVmRnepjKonw9C5FjD8n5TyaBLAfVZaCxf2Z1RDrnPgboeDArSw5qrcQ",
               "revisionDate" => 1_645_717_981_000,
               "summonerLevel" => 128
             } ==
               Request.make(:summoner_by_puuid, "dontbeemotional2", "br1")
    end

    test "(last 5) matches by puuid" do
      %HTTPoison.Response{
        body:
          "[\"BR1_2470228570\",\"BR1_2470213270\",\"BR1_2470220022\",\"BR1_2469322092\",\"BR1_2469252230\"]"
      }
      |> httposion_mock(1)

      assert [
               "BR1_2470228570",
               "BR1_2470213270",
               "BR1_2470220022",
               "BR1_2469322092",
               "BR1_2469252230"
             ] ==
               Request.make(:matches_by_puuid, "dontbeemotional2", "br1")
    end

    defp httposion_mock(response, times) do
      HTTPoisonMock
      |> expect(:get, times, fn _url, _header, _opt ->
        {:ok, response}
      end)
    end
  end
end
