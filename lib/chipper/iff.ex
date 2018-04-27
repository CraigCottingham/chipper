defmodule Chipper.IFF do
  @moduledoc """
  Documentation for Chipper.IFF.
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
