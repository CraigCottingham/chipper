defmodule Chipper.Section do
  @moduledoc """
  Documentation for Chipper.Section.

  A BEAM container is formatted like this (using pseudo-`yecc`):

    Rootsymbol container_contents.

    container_contents -> beam_signature sections.

    beam_signature -> <<0x42, 0x45, 0x41, 0x4D>>.

    sections -> section.
    sections -> section sections.

    section -> "Abst" chunk_size
    section -> "Atom" chunk_size atom_count atoms chunk_padding.
    section -> "Attr" chunk_size
    section -> "AtU8" chunk_size atom_count atoms chunk_padding.
    section -> "CatT" chunk_size
    section -> "CInf" chunk_size
    section -> "Code" chunk_size
    section -> "Dbgi" chunk_size
    section -> "ExDc" chunk_size
    section -> "ExDp" chunk_size
    section -> "ExpT" chunk_size
    section -> "FunT" chunk_size
    section -> "ImpT" chunk_size
    section -> "Line" chunk_size
    section -> "LitT" chunk_size
    section -> "LocT" chunk_size
    section -> "StrT" chunk_size

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
      {:ok, chunk_name, stream} ->
        {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)
        {chunk, stream} = read_section(chunk_name, chunk_length, stream)
        # {:ok, chunk, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}
        {:ok, chunk, stream}

      _ ->
        {:error, :container_not_found}
    end
  end

  # Abst
  defp read_section(<<0x41, 0x62, 0x73, 0x74>>, chunk_length, stream), do: read_ast(chunk_length, stream)
  # Atom
  defp read_section(<<0x41, 0x74, 0x6F, 0x6D>>, chunk_length, stream), do: read_atom_table(chunk_length, stream)
  # Attr
  defp read_section(<<0x41, 0x74, 0x74, 0x72>>, chunk_length, stream), do: read_attributes(chunk_length, stream)
  # AtU8
  defp read_section(<<0x41, 0x74, 0x55, 0x38>>, chunk_length, stream), do: read_atom_utf8_table(chunk_length, stream)
  # CatT
  defp read_section(<<0x43, 0x61, 0x74, 0x54>>, chunk_length, stream), do: read_catch_table(chunk_length, stream)
  # CInf
  defp read_section(<<0x43, 0x49, 0x6E, 0x66>> = chunk_name, chunk_length, stream), do: skip_section(chunk_name, chunk_length, stream)
  # Code
  defp read_section(<<0x43, 0x6F, 0x64, 0x65>>, chunk_length, stream), do: read_compiled_bytecode(chunk_length, stream)
  # Dbgi
  defp read_section(<<0x44, 0x62, 0x67, 0x69>> = chunk_name, chunk_length, stream), do: skip_section(chunk_name, chunk_length, stream)
  # ExDc
  defp read_section(<<0x45, 0x78, 0x44, 0x63>> = chunk_name, chunk_length, stream), do: skip_section(chunk_name, chunk_length, stream)
  # ExDp
  defp read_section(<<0x45, 0x78, 0x44, 0x70>> = chunk_name, chunk_length, stream), do: skip_section(chunk_name, chunk_length, stream)
  # ExpT
  defp read_section(<<0x45, 0x78, 0x70, 0x54>>, chunk_length, stream), do: read_exports_table(chunk_length, stream)
  # FunT
  defp read_section(<<0x46, 0x75, 0x6E, 0x54>>, chunk_length, stream), do: read_function_lambda_table(chunk_length, stream)
  # ImpT
  defp read_section(<<0x49, 0x6D, 0x70, 0x54>>, chunk_length, stream), do: read_imports_table(chunk_length, stream)
  # Line
  defp read_section(<<0x4C, 0x69, 0x6E, 0x65>>, chunk_length, stream), do: read_line_numbers_table(chunk_length, stream)
  # LitT
  defp read_section(<<0x4C, 0x69, 0x74, 0x54>>, chunk_length, stream), do: read_literals_table(chunk_length, stream)
  # LocT
  defp read_section(<<0x4C, 0x6F, 0x63, 0x54>>, chunk_length, stream), do: read_local_functions(chunk_length, stream)
  # StrT
  defp read_section(<<0x53, 0x74, 0x72, 0x54>>, chunk_length, stream), do: read_strings_table(chunk_length, stream)

  # ????
  defp read_section(chunk_name, chunk_length, stream) do
    Logger.debug(fn -> "#{inspect self()}: found #{inspect chunk_name} (#{Base.encode16(chunk_name)})" end)
    skip_section(chunk_name, chunk_length, stream)
  end

  defp skip_section(chunk_name, chunk_length, stream) do
    Logger.debug(fn -> "#{inspect self()}: skipping #{chunk_length} bytes" end)
    {{chunk_name, chunk_length, nil}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}
  end
end
