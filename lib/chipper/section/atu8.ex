defmodule Chipper.Section.AtU8 do
  @moduledoc """
  Documentation for Chipper.Section.AtU8.

  An "AtU8" section is formatted like this (using pseudo-`yecc`):

    Rootsymbol section.

    section -> "AtU8" chunk_size atom_count atoms chunk_padding.

  """

  require Logger

  @doc """
  Read an "AtU8" section.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec read(any()) :: any()
  def read(stream) do
    {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

    {:ok, chunk_data, stream} = Chipper.BinaryUtils.read_n(stream, chunk_length)
    stream = Stream.drop(stream, (Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4) - chunk_length))

    {:ok, {"AtU8", chunk_length, chunk_data}, stream}
  end
end
