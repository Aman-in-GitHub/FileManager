defmodule FileManager do
  @moduledoc """
  Documentation for `FileManager`.
  """
  use Application

  def start(_type, _args) do
    FileManager.hello()

    Supervisor.start_link([], strategy: :one_for_one)
  end

  @doc """
  Prints Hello World to the console

  ## Examples
      iex> FileManager.hello()
      Hello World
      :ok
  """
  def hello() do
    IO.puts("Hello World")
  end
end
