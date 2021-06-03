defmodule StatsApp.Writer do
  NimbleCSV.define(Dumper,
    separator: ",",
    escape: "\""
  )

  def dump_to_file(file_path, output_contents) do
    Dumper.dump_to_stream(output_contents)
    |> Stream.into(File.stream!(file_path, [:write, :utf8]))
    |> Stream.run()
  end
end
