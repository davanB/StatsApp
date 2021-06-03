# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     StatsApp.Repo.insert!(%StatsApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule SeedHelper do
  def parse_json_and_insert_entries(filename) do
    with {:ok, body} <- File.read(filename),
         {:ok, json} <- Jason.decode(body) do
      json
      |> Enum.map(&convert_to_rushing_stats_schema/1)
      |> Enum.map(&StatsApp.RushingStatsRecords.insert_rushing_stat_record/1)
    end
  end

  defp convert_to_rushing_stats_schema(json_entry) do
    %{
      "Player" => player,
      "Team" => team,
      "Pos" => pos,
      "Att" => att,
      "Att/G" => att_g,
      "Yds" => yds,
      "Avg" => avg,
      "Yds/G" => yds_g,
      "TD" => td,
      "Lng" => lng,
      "1st" => first,
      "1st%" => first_percentage,
      "20+" => twenty_plus,
      "40+" => forty_plus,
      "FUM" => fum
    } = json_entry

    lng_and_lng_t =
      lng
      |> try_parse_int()
      |> parse_lng_and_lng_t()

    %{
      "player" => player,
      "team" => team,
      "pos" => pos,
      "att" => att,
      "att_g" => att_g,
      "yds" => parse_yds(yds),
      "avg" => avg,
      "yds_g" => yds_g,
      "td" => td,
      "first" => first,
      "first_percentage" => first_percentage,
      "twenty_plus" => twenty_plus,
      "forty_plus" => forty_plus,
      "fum" => fum
    }
    |> Map.merge(lng_and_lng_t)
  end

  defp try_parse_int(lng) when is_binary(lng) do
    Integer.parse(lng)
  end

  defp try_parse_int(lng), do: {lng, nil}

  defp parse_lng_and_lng_t({lng, "T"}) do
    %{
      "lng" => lng,
      "lng_t" => true
    }
  end

  defp parse_lng_and_lng_t({lng, _}) do
    %{
      "lng" => lng,
      "lng_t" => false
    }
  end

  defp parse_yds(yds) when is_binary(yds) do
    String.replace(yds, ",", "")
  end

  defp parse_yds(yds), do: yds
end

priv_dir = :code.priv_dir(:stats_app)
rushing_json = "#{priv_dir}/repo/rushing.json"

SeedHelper.parse_json_and_insert_entries(rushing_json)
