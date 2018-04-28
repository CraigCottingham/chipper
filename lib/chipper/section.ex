defmodule Chipper.Section do
  @moduledoc """
  Documentation for Chipper.Section.

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
  Read a BEAM section.

  Returns `{:ok, [sections]}` or `{:error, reason}`.
  """
  @spec read(any()) :: any()
  def read(stream) do
    # Logger.debug(fn -> "#{inspect self()}: in Chipper.Section.read/1; stream = #{inspect stream}" end)

    case Chipper.BinaryUtils.read_4(stream) do
      {:ok, <<0x41, 0x74, 0x74, 0x72>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'Attr'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x41, 0x74, 0x55, 0x38>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'AtU8'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x43, 0x49, 0x6E, 0x66>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'CInf'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x43, 0x6F, 0x64, 0x65>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'Code'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x44, 0x62, 0x67, 0x69>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'Dbgi'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x45, 0x78, 0x44, 0x63>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'ExDc'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x45, 0x78, 0x44, 0x70>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'ExDp'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x45, 0x78, 0x70, 0x54>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'ExpT'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x49, 0x6D, 0x70, 0x54>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'ImpT'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x4C, 0x69, 0x6E, 0x65>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'Line'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x4C, 0x6F, 0x63, 0x54>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'LocT'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, <<0x53, 0x74, 0x72, 0x54>> = chunk_name, stream} ->
        # Logger.debug(fn -> "#{inspect self()}: found 'StrT'" end)
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)

        {:ok, {chunk_name, chunk_length}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}

      {:ok, bin, _stream} ->
        Logger.debug(fn -> "#{inspect self()}: found #{inspect bin} (#{Base.encode16(bin)})" end)
        {:error, :container_not_found}

      _ ->
        {:error, :container_not_found}
    end
  end
end
