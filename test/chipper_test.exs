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
        {"AtU8", 119, data} ->
          Logger.debug(fn -> inspect data end)
          assert true
        {"Code", 143, _} ->
          assert true
        {"StrT", 0, _} ->
          assert true
        {"ImpT", 28, _} ->
          assert true
        {"ExpT", 40, _} ->
          assert true
        {"LocT", 4, _} ->
          assert true
        {"Attr", 40, _} ->
          assert true
        {"CInf", 105, _} ->
          assert true
        {"Dbgi", 169, _} ->
          assert true
        {"ExDc", 86, _} ->
          assert true
        {"ExDp", 27, _} ->
          assert true
        {"Line", 20, _} ->
          assert true
        {chunk_name, chunk_length} ->
          Logger.error(fn -> "unknown chunk name #{inspect chunk_name} with length #{chunk_length}" end)
        other ->
          Logger.error(fn -> "unrecognized chunk #{inspect other}" end)
      end
    end
  end
end
