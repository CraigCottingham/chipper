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

  @spec read_n(any(), non_neg_integer()) :: {:ok, binary(), any()} | {:error, atom(), any()}
  def read_n(stream, n) do
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

  @spec read_u32_big(any()) :: {:ok, non_neg_integer(), any()} | {:error, atom(), any()}
  def read_u32_big(stream) do
    {:ok, <<num::big-unsigned-integer-size(32)>>, stream} = read_4(stream)
    {:ok, num, stream}
  end

  @doc """
  Pad a value to an alignment multiple.

  aligned_value = multiple * ((unaligned_value + multiple - 1) / multiple)

  See http://beam-wisdoms.clau.se/en/latest/indepth-beam-file.html

  ## Examples

      iex> Chipper.BinaryUtils.pad_to_multiple(119, 4)
      120

      iex> Chipper.BinaryUtils.pad_to_multiple(120, 4)
      120

      iex> Chipper.BinaryUtils.pad_to_multiple(121, 4)
      124

      iex> Chipper.BinaryUtils.pad_to_multiple(0, 4)
      0

  """
  @spec pad_to_multiple(non_neg_integer(), non_neg_integer()) :: non_neg_integer()
  def pad_to_multiple(unaligned_value, multiple), do: multiple * div((unaligned_value + multiple - 1), multiple)
end
