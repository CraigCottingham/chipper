defmodule Chipper.Section.Atom do
  @moduledoc """
  Documentation for Chipper.Section.Atom.

  An "Atom" section is formatted like this (using pseudo-`yecc`):

    Rootsymbol section.

    section -> "Atom" chunk_size atom_count atoms chunk_padding.

  """

  require Logger

  @doc """
  Read an "Atom" section.

  Returns `{{chunk_name, chunk_length, chunk_data}, stream}` or {:error, reason}.
  """
  @spec read(any()) :: any()
  def read(stream) do
    {:ok, chunk_length, stream} = Chipper.BinaryUtils.read_u32_big(stream)

    {:ok, num_atoms, stream} = Chipper.BinaryUtils.read_u32_big(stream)

    {atoms, stream} = Enum.reduce(
                        1..num_atoms,
                        {[], stream},
                        fn _, {atoms, stream} ->
                          {:ok, atom_length, stream} = Chipper.BinaryUtils.read_u8(stream)
                          {:ok, atom, stream} = Chipper.BinaryUtils.read_n(stream, atom_length)
                          {[atoms, atom], stream}
                        end
                      )

    stream = Stream.drop(stream, (Chipper.BinaryUtils.pad_to_multiple(chunk_length, 4) - chunk_length))

    {
      :ok,
      {
        "Atom",
        chunk_length,
        %{
          atoms: List.flatten(atoms)
        }
      },
      stream
    }
  end
end
