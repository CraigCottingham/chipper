defmodule Chipper.Section.Abst do
  @moduledoc """
  Documentation for Chipper.Section.Abst.

  An "Abst" section is formatted like this (using pseudo-`yecc`):

    Rootsymbol section.

    section -> "Abst" chunk_size chunk_data chunk_padding.

  """

  require Logger

  @doc """
  Read an "Abst" section.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec read(any()) :: any()
  def read(stream) do
    {:ok, chunk_length, stream} = Chipper.BinaryUtils.read_u32_big(stream)

    {:ok, chunk_data, stream} = Chipper.BinaryUtils.read_n(stream, chunk_length)
    stream = Stream.drop(stream, (Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4) - chunk_length))

    {
      :ok,
      {
        "Abst",
        chunk_length,
        chunk_data,
      },
      stream
    }
  end
end
