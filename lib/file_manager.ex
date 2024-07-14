defmodule FileManager do
  @moduledoc """
  Documentation for `FileManager`.
  """

  use Application

  alias FileManager.Init
  alias FileManager.CRUD

  def start(_type, _args) do
    Init.init()
    run()

    Supervisor.start_link([], strategy: :one_for_one)
  end

  def run() do
    IO.puts("\nID  Task")

    options = %{
      1 => "Create a file",
      2 => "Read a file",
      3 => "Update a file",
      4 => "Delete a file",
      5 => "Delete a directory",
      6 => "Format disk",
      7 => "Exit"
    }

    Enum.map(options, fn {key, value} ->
      IO.puts("#{key} - #{value}")
    end)

    try do
      {input, _} =
        IO.gets("\nEnter the ID of the task you want to perform: ")
        |> String.trim()
        |> Integer.parse()

      if(input > 0 && input <= map_size(options)) do
        case input do
          1 ->
            CRUD.create_a_file()

          2 ->
            CRUD.read_a_file()

          3 ->
            CRUD.update_a_file()

          4 ->
            CRUD.delete_a_file()

          5 ->
            CRUD.delete_a_directory()

          6 ->
            CRUD.format_disk()

          7 ->
            Exit.exit()
        end

        run()
      else
        IO.puts("Error: You chose an invalid option")

        run()
      end
    rescue
      _ ->
        IO.puts("Error: Enter a valid ID")

        run()
    end
  end
end
