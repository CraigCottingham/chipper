defmodule Chipper.BEAM do
  @moduledoc """
  Documentation for Chipper.BEAM.

  A BEAM container is formatted like this (using pseudo-`yecc`):

    Rootsymbol container_contents.

    container_contents -> beam_signature sections.

    beam_signature -> <<0x42, 0x45, 0x41, 0x4D>>.

    sections -> section.
    sections -> section sections.

    section -> "Atom" chunk_size atom_count atoms chunk_padding.
    section -> "AtU8" chunk_size atom_count atoms chunk_padding.
    section -> "Code" chunk_size
    section -> "CatT" chunk_size
    section -> "FunT" chunk_size
    section -> "ExpT" chunk_size
    section -> "LitT" chunk_size
    section -> "ImpT" chunk_size
    section -> "LocT" chunk_size
    section -> "Line" chunk_size
    section -> "StrT" chunk_size
    section -> "Attr" chunk_size

    atom_count -> u32_big.

    atoms -> atom.
    atoms -> atom atoms.

    atom -> string_length string.

    string_length -> u8.

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
      {:ok, <<0x42, 0x45, 0x41, 0x4D>>, stream} ->
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
        # {:ok, []}

      {:ok, _bin, _stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found #{inspect (bin <> <<0>>)}" end)
        {:error, :container_not_found}

      _ ->
        {:error, :container_not_found}
    end
  end
end
