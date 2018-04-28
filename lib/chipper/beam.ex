defmodule Chipper.BEAM do
  @moduledoc """
  Documentation for Chipper.BEAM.

  A BEAM container is formatted like this (using pseudo-`yecc`):

    Rootsymbol container_contents.

    container_contents -> beam_signature sections.

    beam_signature -> <<0x42, 0x45, 0x41, 0x4D>>.

    sections -> section.
    sections -> section sections.
  """

  require Logger

  @doc """
  Read a BEAM container.

  Returns `{:ok, [sections]}` or `{:error, reason}`.
  """
  @spec read(any()) :: any()
  def read(stream) do
    # Logger.debug(fn -> "#{inspect self()}: in Chipper.BEAM.read/1; stream = #{inspect stream}" end)

    case Chipper.BinaryUtils.read_4(stream) do
      {:ok, "BEAM", stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'BEAM'" end)

        sections = Stream.resource(fn -> stream end,
                                   fn stream ->
                                     case Chipper.Section.read(stream) do
                                       {:ok, section, stream} -> {[section], stream}
                                       _ -> {:halt, stream}
                                     end
                                   end,
                                   fn _ -> nil end)
                   |> Enum.to_list
        {:ok, sections}

      {:ok, _bin, _stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found #{inspect (bin <> <<0>>)}" end)
        {:error, :container_not_found}

      _ ->
        {:error, :container_not_found}
    end
  end
end
