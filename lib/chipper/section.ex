defmodule Chipper.Section do
  @moduledoc """
  Documentation for Chipper.Section.

  A BEAM section is formatted like this (using pseudo-`yecc`):

    Rootsymbol section.

    section -> chunk_name chunk_size chunk_data chunk_padding.

  See Chipper.Section.* for specific sections.
  """

  require Logger

  alias Chipper.Section.Abst, as: Abst
  alias Chipper.Section.Atom, as: Atom
  alias Chipper.Section.Attr, as: Attr
  alias Chipper.Section.AtU8, as: AtU8
  alias Chipper.Section.CatT, as: CatT
  alias Chipper.Section.CInf, as: CInf
  alias Chipper.Section.Code, as: Code
  alias Chipper.Section.Dbgi, as: Dbgi
  alias Chipper.Section.ExDc, as: ExDc
  alias Chipper.Section.ExDp, as: ExDp
  alias Chipper.Section.ExpT, as: ExpT
  alias Chipper.Section.FunT, as: FunT
  alias Chipper.Section.ImpT, as: ImpT
  alias Chipper.Section.Line, as: Line
  alias Chipper.Section.LitT, as: LitT
  alias Chipper.Section.LocT, as: LocT
  alias Chipper.Section.StrT, as: StrT

  @doc """
  Read a BEAM section.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec read(any()) :: any()
  def read(stream) do
    # Logger.debug(fn -> "#{inspect self()}: in Chipper.Section.read/1; stream = #{inspect stream}" end)

    case Chipper.BinaryUtils.read_4(stream) do
      {:ok, chunk_name, stream} ->
        read_section(chunk_name, stream)

      _ ->
        {:error, :container_not_found}
    end
  end

  defp read_section("Abst", stream), do: Abst.read(stream)
  defp read_section("Atom", stream), do: Atom.read(stream)
  defp read_section("Attr", stream), do: Attr.read(stream)
  defp read_section("AtU8", stream), do: AtU8.read(stream)
  defp read_section("CatT", stream), do: CatT.read(stream)
  defp read_section("CInf", stream), do: CInf.read(stream)
  defp read_section("Code", stream), do: Code.read(stream)
  defp read_section("Dbgi", stream), do: Dbgi.read(stream)
  defp read_section("ExDc", stream), do: ExDc.read(stream)
  defp read_section("ExDp", stream), do: ExDp.read(stream)
  defp read_section("ExpT", stream), do: ExpT.read(stream)
  defp read_section("FunT", stream), do: FunT.read(stream)
  defp read_section("ImpT", stream), do: ImpT.read(stream)
  defp read_section("Line", stream), do: Line.read(stream)
  defp read_section("LitT", stream), do: LitT.read(stream)
  defp read_section("LocT", stream), do: LocT.read(stream)
  defp read_section("StrT", stream), do: StrT.read(stream)

  # ????
  defp read_section(chunk_name, stream) do
    Logger.debug(fn -> "#{inspect self()}: found #{inspect chunk_name} (#{Base.encode16(chunk_name)})" end)
    skip_section(chunk_name, stream)
  end

  @doc """
  Skip a section.
  Useful for when a section type is unknown or not implemented.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec skip_section(binary(), any()) :: {{binary(), integer(), any()}, any()}
  def skip_section(chunk_name, stream) do
    {:ok, <<chunk_length::big-unsigned-integer-size(32)>>, stream} = Chipper.BinaryUtils.read_4(stream)
    Logger.debug(fn -> "#{inspect self()}: #{chunk_name} - skipping #{chunk_length} bytes" end)
    {{chunk_name, chunk_length, nil}, Stream.drop(stream, Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4))}
  end
end
