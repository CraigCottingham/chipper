defmodule ChipperTest do
  use ExUnit.Case, async: true

  require Logger

  doctest Chipper
  doctest Chipper.BEAM
  doctest Chipper.BinaryUtils
  doctest Chipper.IFF
  doctest Chipper.Section
  doctest Chipper.Section.Abst
  doctest Chipper.Section.Atom
  doctest Chipper.Section.Attr
  doctest Chipper.Section.AtU8
  doctest Chipper.Section.CatT
  doctest Chipper.Section.CInf
  doctest Chipper.Section.Code
  doctest Chipper.Section.Dbgi
  doctest Chipper.Section.ExDc
  doctest Chipper.Section.ExDp
  doctest Chipper.Section.ExpT
  doctest Chipper.Section.FunT
  doctest Chipper.Section.ImpT
  doctest Chipper.Section.Line
  doctest Chipper.Section.LitT
  doctest Chipper.Section.LocT
  doctest Chipper.Section.StrT

  test "disassemble Elixir.Hello.beam" do
    {:ok, beam_size, sections} = Chipper.main(["test/Elixir.Hello.beam"])
    assert beam_size == 900
    assert is_list(sections)
    assert Enum.count(sections) == 12

    for section <- sections do
      case section do
        {"Attr", 40, data} ->
          # Logger.debug(fn -> "Attr: #{inspect data}" end)
          assert is_list(data.term)
          assert (data.term |> List.first |> elem(0)) == :vsn

        {"AtU8", 119, data} ->
          # Logger.debug(fn -> "AtU8: #{inspect data}" end)
          assert is_map(data)
          assert is_list(data.atoms)
          assert Enum.count(data.atoms) == 12

        {"CInf", 105, _data} ->
          # Logger.debug(fn -> "CInf: #{inspect data}" end)
          assert true

        {"Code", 143, data} ->
          Logger.debug(fn -> "Code: #{inspect data}" end)
          assert true

        {"Dbgi", 169, _data} ->
          # Logger.debug(fn -> "Dbgi: #{inspect data}" end)
          assert true

        {"ExDc", 86, _data} ->
          # Logger.debug(fn -> "ExDc: #{inspect data}" end)
          assert true

        {"ExDp", 27, _data} ->
          # Logger.debug(fn -> "ExDp: #{inspect data}" end)
          assert true

        {"ExpT", 40, data} ->
          Logger.debug(fn -> "ExpT: #{inspect data}" end)
          assert true

        {"ImpT", 28, data} ->
          Logger.debug(fn -> "ImpT: #{inspect data}" end)
          assert true

        {"Line", 20, data} ->
          # Logger.debug(fn -> "Line: #{inspect data}" end)
          assert data.version == 0
          # assert data.flags
          assert data.line_instr_count == 8
          assert data.num_line_refs == 0
          assert data.num_filenames == 0

        {"LocT", 4, data} ->
          Logger.debug(fn -> "LocT: #{inspect data}" end)
          assert true

        {"StrT", 0, data} ->
          Logger.debug(fn -> "StrT: #{inspect data}" end)
          assert true

        {chunk_name, chunk_length} ->
          Logger.error(fn -> "unknown chunk name #{inspect chunk_name} with length #{chunk_length}" end)

        other ->
          Logger.error(fn -> "unrecognized chunk #{inspect other}" end)
      end
    end
  end
end
