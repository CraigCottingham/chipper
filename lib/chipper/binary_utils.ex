defmodule Chipper.BinaryUtils do
  @moduledoc """
  Documentation for Chipper.BinaryUtils.

  """

  @doc """
  Read a 4-byte binary.

  ## Examples

      iex> {:ok, stream} = StringIO.open(<<0x01, 0x02, 0x03, 0x04>>)
      iex> {:ok, bin, _} = Chipper.BinaryUtils.read_4(IO.binstream(stream, 1))
      iex> bin
      <<0x01, 0x02, 0x03, 0x04>>

      iex> {:ok, stream} = StringIO.open(<<0x05, 0x06, 0x07, 0x08, 0x09>>)
      iex> {:ok, bin, _} = Chipper.BinaryUtils.read_4(IO.binstream(stream, 1))
      iex> bin
      <<0x05, 0x06, 0x07, 0x08>>

      iex> {:ok, stream} = StringIO.open(<<0x0A, 0x0B, 0x0C>>)
      iex> {:error, reason, _} = Chipper.BinaryUtils.read_4(IO.binstream(stream, 1))
      iex> reason
      :insufficient_data

  """
  @spec read_4(any()) :: {:ok, binary(), any()} | {:error, atom(), any()}
  def read_4(stream), do: read_n(stream, 4)

  @doc """
  Read an 8-byte binary.

  ## Examples

      iex> {:ok, stream} = StringIO.open(<<0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01>>)
      iex> {:ok, bin, _} = Chipper.BinaryUtils.read_8(IO.binstream(stream, 1))
      iex> bin
      <<0x08, 0x07, 0x06, 0x05, 0x04, 0x03, 0x02, 0x01>>

      iex> {:ok, stream} = StringIO.open(<<0x18, 0x27, 0x36, 0x45, 0x54, 0x63, 0x72, 0x81, 0x90>>)
      iex> {:ok, bin, _} = Chipper.BinaryUtils.read_8(IO.binstream(stream, 1))
      iex> bin
      <<0x18, 0x27, 0x36, 0x45, 0x54, 0x63, 0x72, 0x81>>

      iex> {:ok, stream} = StringIO.open(<<0xFA, 0xEB, 0xDC>>)
      iex> {:error, reason, _} = Chipper.BinaryUtils.read_8(IO.binstream(stream, 1))
      iex> reason
      :insufficient_data

  """
  @spec read_8(any()) :: {:ok, binary(), any()} | {:error, atom(), any()}
  def read_8(stream), do: read_n(stream, 8)

  defp read_n(stream, n) do
    bin = stream
          |> Stream.take(n)
          |> Enum.to_list
          |> :erlang.list_to_binary

    if byte_size(bin) == n do
      {:ok, bin, Stream.drop(stream, n)}
    else
      {:error, :insufficient_data, stream}
    end
  end
end
