defmodule Chipper.Section.Code do
  @moduledoc """
  Documentation for Chipper.Section.Code.

  A "Code" section is formatted like this (using pseudo-`yecc`):

    Rootsymbol section.

    section -> "Code" chunk_size chunk_data chunk_padding.

  """

  require Logger

  @doc """
  Read a "Code" section.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec read(any()) :: any()
  def read(stream) do
    {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

    stream = Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))

    {:ok, {"Code", chunk_length}, stream}
  end
end
