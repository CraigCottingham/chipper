defmodule Chipper.IFF do
  @moduledoc """
  Documentation for Chipper.IFF.
  """

  @doc """
  Read an IFF container.

  Returns `{:ok, [sections]}` or `{:error, reason}`.
  """
  @spec read(any()) :: any()
  def read(_stream) do
    {:ok, []}
  end
end
