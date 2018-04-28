defmodule Chipper.Section.ExDc do
  @moduledoc """
  Documentation for Chipper.Section.ExDc.

  An "ExDc" section is formatted like this (using pseudo-`yecc`):

    Rootsymbol section.

    section -> "ExDc" chunk_size chunk_data chunk_padding.

  """

  require Logger

  @doc """
  Read a "ExDc" section.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec read(any()) :: any()
  def read(stream) do
    {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

    {:ok, chunk_data, stream} = Chipper.BinaryUtils.read_n(stream, chunk_length)
    stream = Stream.drop(stream, (Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4) - chunk_length))

    {:ok, {"ExDc", chunk_length, chunk_data}, stream}
  end
end
