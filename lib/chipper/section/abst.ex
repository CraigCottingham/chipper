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
    {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

    stream = Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))

    {:ok, {"Abst", chunk_length}, stream}
  end
end
