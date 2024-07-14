defmodule FileManager.FileStruct do
  @moduledoc """
  Defines a struct for file metadata and content.
  """

  @type t :: %__MODULE__{
          dir: String.t(),
          name: String.t(),
          ext: String.t(),
          content: String.t()
        }

  defstruct(
    dir: "",
    name: "",
    ext: "",
    content: ""
  )
end
