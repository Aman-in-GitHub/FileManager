defmodule FileManager.CRUD do
  @moduledoc """
  Defines functions for CRUD operations
  """

  alias FileManager.FileStruct

  @spec get_input(String.t()) :: String.t() | :error
  defp get_input(type) do
    if type === "content" do
      input = IO.gets("#{type} of the file: ") |> String.trim()
      input
    else
      input = IO.gets("Name of the #{type}: ") |> String.trim()
      input
    end
  end

  @spec write_to_a_file(FileStruct.t(), String.t()) :: :ok | :error
  defp write_to_a_file(file, path) do
    case File.write(path, file.content, [:exclusive]) do
      :ok ->
        IO.puts("Success: File created successfully at #{path}")
        :ok

      {:error, :eexist} ->
        IO.puts("Error: #{file.name}.#{file.ext} already exists at #{path}")
        :error

      _ ->
        IO.puts("Error: File creation failed")
        :error
    end
  end

  @spec get_file_path_from_user(String.t(), String.t()) :: String.t() | :error
  defp get_file_path_from_user(directory_path, filename) do
    case File.ls("#{directory_path}") do
      {:ok, files} ->
        matching_files =
          Enum.reduce(files, [], fn file, acc ->
            if file === nil do
              throw("Error: Invalid file")
            end

            file = String.split(file, ".")

            case file do
              [name, ext] ->
                if name === filename do
                  ["#{name}.#{ext}" | acc]
                else
                  acc
                end

              _ ->
                acc
            end
          end)

        cond do
          length(matching_files) === 0 ->
            throw("Error: Couldn't find file named #{filename} at #{directory_path}")

          length(matching_files) === 1 ->
            "#{directory_path}/#{Enum.at(matching_files, 0)}"

          true ->
            IO.puts(
              "Success: Found #{length(matching_files)} matching your query of #{filename}\n"
            )

            IO.puts("ID  Name")

            matching_files
            |> Enum.with_index()
            |> Enum.map(fn {element, index} ->
              IO.puts("#{index + 1} - #{element}")
            end)

            try do
              {input, _} =
                IO.gets("\nEnter the ID of the file you want to choose: ")
                |> String.trim()
                |> Integer.parse()

              if input > 0 && input <= length(matching_files) do
                file = Enum.at(matching_files, input - 1)
                "#{directory_path}/#{file}"
              else
                IO.puts("Error: You chose an invalid option")
                :error
              end
            rescue
              _ ->
                IO.puts("Error: Enter a valid ID")
                :error
            end
        end

      _ ->
        IO.puts("Error listing files at #{directory_path}")
        :error
    end
  end

  @spec create_a_file() :: :ok | :error
  def create_a_file do
    IO.puts("\n-------------")
    IO.puts("CREATE A FILE")
    IO.puts("-------------\n")

    directory = get_input("directory")
    filename = get_input("filename")
    extension = get_input("extension")
    content = get_input("content")

    file = %FileStruct{
      dir: directory,
      name: filename,
      ext: extension,
      content: content
    }

    extensions = ["txt", "md"]

    if file.dir === "" || file.name === "" || file.ext === "" do
      throw("Error: Provide a directory, name, and extension")
    end

    unless Enum.member?(extensions, file.ext) do
      throw(
        "Error: Invalid extension\n(Allowed file types: #{Enum.at(extensions, 0)} and #{Enum.at(extensions, 1)})"
      )
    end

    folder_path = "fs/#{file.dir}"
    file_path = "fs/#{file.dir}/#{file.name}.#{file.ext}"

    case File.stat(folder_path) do
      {:error, :enoent} ->
        case File.mkdir(folder_path) do
          :ok ->
            IO.puts("Success: Directory created successfully at #{folder_path}")
            write_to_a_file(file, file_path)

          _ ->
            IO.puts("Error: Directory creation failed")
        end

      {:ok, _info} ->
        write_to_a_file(file, file_path)
    end
  catch
    value ->
      IO.puts(value)
      :error
  end

  @spec read_a_file() :: :ok | :error
  def read_a_file() do
    IO.puts("\n-----------")
    IO.puts("READ A FILE")
    IO.puts("-----------\n")

    directory = get_input("directory")
    filename = get_input("filename")

    if directory === "" || filename === "" do
      throw("Error: Provide a directory and a filename")
    end

    directory_path = "fs/#{directory}"

    if !File.exists?(directory_path) do
      throw("Error: #{directory_path} doesn't exist")
    end

    file_path = get_file_path_from_user(directory_path, filename)
    {:ok, content} = File.read(file_path)
    content = content |> String.trim()

    IO.puts("\nFILE: #{file_path}\n")

    if(content === "") do
      IO.puts("This file is empty")
    else
      IO.puts(content)
    end
  catch
    value ->
      IO.puts(value)
      :error
  end

  @spec update_a_file() :: :ok | :error
  def update_a_file() do
    IO.puts("\n-------------")
    IO.puts("UPDATE A FILE")
    IO.puts("-------------\n")

    directory = get_input("directory")
    filename = get_input("filename")
    content = get_input("content")

    if directory === "" || filename === "" do
      throw("Error: Provide a directory and a filename")
    end

    directory_path = "fs/#{directory}"

    if !File.exists?(directory_path) do
      throw("Error: #{directory_path} doesn't exist")
    end

    file_path = get_file_path_from_user(directory_path, filename)

    if(file_path === :error) do
      :error
    else
      case File.write(file_path, content) do
        :ok ->
          IO.puts("Success: #{file_path} updated successfully")
          :ok

        _ ->
          IO.puts("Error: Updating file failed")
          :error
      end
    end
  end

  @spec delete_a_file() :: :ok | :error
  def delete_a_file() do
    IO.puts("\n-------------")
    IO.puts("DELETE A FILE")
    IO.puts("-------------\n")

    directory = get_input("directory")
    filename = get_input("filename")

    if directory === "" || filename === "" do
      throw("Error: Provide a directory and a filename")
    end

    directory_path = "fs/#{directory}"

    if !File.exists?(directory_path) do
      throw("Error: #{directory_path} doesn't exist")
    end

    file_path = get_file_path_from_user(directory_path, filename)

    if(file_path === :error) do
      :error
    else
      case File.rm(file_path) do
        :ok ->
          IO.puts("Success: #{file_path} deleted successfully")
          :ok

        _ ->
          IO.puts("Error: Deleting file failed")
          :error
      end
    end
  catch
    value ->
      IO.puts(value)
      :error
  end

  @spec delete_a_directory() :: :ok | :error
  def delete_a_directory() do
    IO.puts("\n------------------")
    IO.puts("DELETE A DIRECTORY")
    IO.puts("------------------\n")

    directory = get_input("directory")

    if directory === "" do
      throw("Error: Provide a directory and a filename")
    end

    directory_path = "fs/#{directory}"

    if !File.exists?(directory_path) do
      throw("Error: #{directory_path} doesn't exist")
    end

    case File.rm_rf(directory_path) do
      {:ok, _} ->
        IO.puts("Success: #{directory_path} deleted successfully")

      _ ->
        IO.puts("Error: Deleting directory failed")
        :error
    end
  end

  @spec format_disk() :: :ok | :error
  def format_disk() do
    IO.puts("\n-----------")
    IO.puts("FORMAT DISK")
    IO.puts("-----------\n")

    root = "fs"

    root
    |> File.ls()
    |> case do
      {:ok, items} ->
        items
        |> Enum.map(&Path.join(root, &1))
        |> Enum.filter(&File.dir?/1)
        |> Enum.each(&File.rm_rf/1)

        IO.puts("Success: Formatted disk successfully")

      _ ->
        IO.puts("Error: Formatting disk failed")
        :error
    end
  end
end
