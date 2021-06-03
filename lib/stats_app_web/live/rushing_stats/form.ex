defmodule StatsAppWeb.RushingStats.Form do
  import Ecto.Changeset

  @schema %{
    player: :string
  }

  def new() do
    validate("")
  end

  def validate(player) do
    %{player: player}
    |> cast()
    |> validate_format(:player, ~r/\p{L}/, message: "Player names only contain letters!")
  end

  defp cast(attrs) do
    {%{}, @schema}
    |> cast(attrs, [:player])
  end
end
