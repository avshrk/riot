defmodule Riot.Request do
  @moduledoc """
  Request Context
  """

  @api_key Application.compile_env(:riot, :riot_api_key)
  @api_subdomain Application.compile_env(:riot, :riot_api_subdomain)
  @headers ["X-Riot-Token": @api_key]
  @httpoison_backend Application.compile_env(:riot, :httpoison_backend, HTTPoison)
  @last_match 1
  @last_matches 5
  @regions Application.compile_env(:riot, :regions)

  def make(:summoner_by_name, name, region) do
    region
    |> summoner_by_name_endpoint(name)
    |> request()
  end

  def make(:summoner_by_puuid, puuid, region) do
    region
    |> summoner_by_puuid_endpoint(puuid)
    |> request()
  end

  def make(:matches_by_puuid, puuid, region) do
    region
    |> match_api_region()
    |> match_by_puuid_endpoint(puuid, @last_matches)
    |> request()
  end

  def make(:match_by_puuid, puuid, region) do
    region
    |> match_api_region()
    |> match_by_puuid_endpoint(puuid, @last_match)
    |> request()
  end

  def make(:match_by_match_id, match_id, region) do
    region
    |> match_api_region()
    |> match_by_match_id_endpoint(match_id)
    |> request()
  end

  defp summoner_by_name_endpoint(region, name) do
    "#{region_url(region)}/lol/summoner/v4/summoners/by-name/#{name}"
  end

  defp summoner_by_puuid_endpoint(region, puuid) do
    "#{region_url(region)}/lol/summoner/v4/summoners/by-puuid/#{puuid}"
  end

  defp match_by_puuid_endpoint(region, puuid, last_match_count) do
    "#{region_url(region)}/lol/match/v5/matches/by-puuid/#{puuid}/ids?start=0&count=#{last_match_count}"
  end

  defp match_by_match_id_endpoint(region, match_id) do
    "#{region_url(region)}/lol/match/v5/matches/#{match_id}"
  end

  defp region_url(region), do: "https://#{region}.#{@api_subdomain}"

  defp request(url) do
    url
    |> http_request()
    |> decode_body()
  end

  defp http_request(url) do
    url |> @httpoison_backend.get(@headers, [])
  end

  defp decode_body({:ok, %{body: body}}), do: body |> Poison.decode!()

  defp match_api_region(region) do
    region_key = region |> String.slice(0, 2)

    @regions[region_key]
  end
end
