defmodule Chipper.IFF do
  @moduledoc """
  Documentation for Chipper.IFF.

  An IFF file is formatted like this (using pseudo-`yecc`):

    Rootsymbol iff.

    iff -> containers.

    containers -> container.
    containers -> container containers.

    container -> container_signature container_size container_contents.

  See Chipper.BEAM for the container contents.
  """

  require Logger

  @doc """
  Read an IFF container.

  Returns `{:ok, [sections]}` or `{:error, reason}`.
  """
  @spec read(any()) :: any()
  def read(stream) do
    # Logger.debug(fn -> "#{inspect self()}: in Chipper.IFF.read/1; stream = #{inspect stream}" end)

    case Chipper.BinaryUtils.read_8(stream) do
      {:ok, <<0x46, 0x4F, 0x52, 0x31, container_length::big-unsigned-integer-size(32)>>, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'FOR1'" end)
        case Chipper.BEAM.read(stream) do
          {:ok, sections} -> {:ok, (container_length + 8), sections}
          _ -> {:error, :invalid_container}
        end

      {:ok, <<_::big-unsigned-integer-size(32), bytes_to_skip::big-unsigned-integer-size(32)>>, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found something else, skipping #{bytes_to_skip} bytes" end)
        read(Stream.drop(stream, bytes_to_skip))

      _ ->
        {:error, :container_not_found}
    end
  end
end
