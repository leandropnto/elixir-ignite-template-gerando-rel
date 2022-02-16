defmodule GenReport do
  alias GenReport.Parser

  def build() do
    {:error, "Insira o nome de um arquivo"}
  end

  def build(filename) do
    lines =
      filename
      |> Parser.parse_file()

    hours_per_name = sum_hours_per_name(lines)
    hours_per_name_year = sum_hours_per_name_year(lines)
    hours_per_name_year_month = sum_hours_per_name_month(lines)

    %{
      "all_hours" => hours_per_name,
      "hours_per_month" => hours_per_name_year_month,
      "hours_per_year" => hours_per_name_year
    }
  end

  defp sum_hours_per_name(report) do
    Enum.reduce(report, %{}, fn [name, horas, _dia, _mes, _ano], acc ->
      Map.put(acc, name, (acc[name] || 0) + horas)
    end)
  end

  defp sum_hours_per_name_year(data) do
    Enum.reduce(data, %{}, fn [name, horas, _dia, _mes, ano], acc ->
      Map.put(
        acc,
        name,
        Map.put(acc[name] || %{ano => horas}, ano, (acc[name][ano] || 0) + horas)
      )
    end)
  end

  # defp sum_hours_per_name_year_month(data) do
  #   Enum.reduce(data, %{}, fn [name, horas, _dia, mes, ano], acc ->
  #     Map.put(
  #       acc,
  #       name,
  #       Map.put(
  #         acc[name] || %{ano => horas},
  #         ano,
  #         Map.put(acc[name][ano] || %{}, mes, (acc[name][ano][mes] || 0) + horas)
  #       )
  #     )
  #   end)
  # end

  def sum_hours_per_name_month(data) do
    Enum.reduce(data, %{}, fn [name, hours, _day, month, _year], acc ->
      Map.put(
        acc,
        name,
        Map.put(acc[name] || %{}, month, (acc[name][month] || 0) + hours)
      )
    end)
  end
end
