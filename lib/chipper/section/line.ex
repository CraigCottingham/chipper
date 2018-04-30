defmodule Chipper.Section.Line do
  @moduledoc """
  Documentation for Chipper.Section.Line.

  A "Line" section is formatted like this (using pseudo-`yecc`):

    Rootsymbol section.

    section -> "Line" chunk_size chunk_data chunk_padding.

    chunk_data -> version flags line_instr_count num_line_refs num_filenames.

  """

  require Logger

  @doc """
  Read a "Line" section.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec read(any()) :: any()
  def read(stream) do
    {:ok, chunk_length, stream} = Chipper.BinaryUtils.read_u32_big(stream)

    {:ok, version, stream} = Chipper.BinaryUtils.read_u32_big(stream)
    {:ok, flags, stream} = Chipper.BinaryUtils.read_4(stream)
    {:ok, line_instr_count, stream} = Chipper.BinaryUtils.read_u32_big(stream)
    {:ok, num_line_refs, stream} = Chipper.BinaryUtils.read_u32_big(stream)
    {:ok, num_filenames, stream} = Chipper.BinaryUtils.read_u32_big(stream)
    {:ok, chunk_data, stream} = Chipper.BinaryUtils.read_n(stream, (chunk_length - 20))

    stream = Stream.drop(stream, (Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4) - chunk_length))

    {
      :ok,
      {
        "Line",
        chunk_length,
        %{
          version: version,
          flags: flags,
          line_instr_count: line_instr_count,
          num_line_refs: num_line_refs,
          num_filenames: num_filenames,
          remaining_data: chunk_data
        }
      },
      stream
    }
  end
end
