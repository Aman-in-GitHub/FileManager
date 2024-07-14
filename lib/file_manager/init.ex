defmodule FileManager.Init do
  @moduledoc """
  Sets up the initial configuration
  """

  @spec init() :: :ok
  def init() do
    if !File.exists?("fs") do
      case File.mkdir("fs") do
        :ok ->
          :ok

        _ ->
          IO.puts("FATAL: Error setting up configuration")

          Exit.exit()
      end
    end

    IO.puts("------------------------------")
    IO.puts("WELCOME TO THE FILE MANAGER 🔮")
    IO.puts("------------------------------")
  end
end
