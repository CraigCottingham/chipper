defmodule Chipper.IFF do
  @moduledoc """
  Documentation for Chipper.IFF.

  A BEAM file is formatted like this (using pseudo-`yecc`):

Rootsymbol iff.

iff -> containers.

containers -> container.
containers -> container containers.

container -> container_signature container_size beam_signature sections.

container_signature -> <<0x46, 0x4F, 0x52, 0x31>>.

container_size -> u32_big.

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

  @doc """
  Read an IFF container.

  Returns `{:ok, [sections]}` or `{:error, reason}`.
  """
  @spec read(any()) :: any()
  def read(stream) do
    stream
    |> Stream.take(4)
    |> Enum.to_list
    |> :erlang.list_to_binary
    |> read_container(Stream.drop(stream, 4))
  end

  defp read_container(<<0x46, 0x4F, 0x52, 0x31>>, stream) do
    container_size = stream
                     |> Stream.take(4)
                     |> Enum.to_list
                     |> :erlang.list_to_binary
                     |> get_uint32
    {:ok, []}
  end

  defp read_container(_, stream) do
    container_size = stream
                     |> Stream.take(4)
                     |> Enum.to_list
                     |> :erlang.list_to_binary
                     |> get_uint32
    if is_nil(container_size) do
      {:error, :container_not_found}
    else
      Stream.drop(stream, container_size)
      |> read
    end
  end

  defp get_uint32(<<num::big-unsigned-integer-size(32)>>), do: num
  defp get_uint32(_), do: nil
end
