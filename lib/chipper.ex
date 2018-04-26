defmodule Chipper do
  @moduledoc """
  Documentation for Chipper.
  """

  @doc """
  Entry point for CLI tool.

  ## Examples

      iex> Chipper.main()
      :ok

  """
  @spec main(list()) :: none()
  def main(args \\ []) do
    {_opts, _, _} = OptionParser.parse(
                      args,
                      switches: [start: :integer, end: :integer, src: :string, dest: :string, update_tags: :string],
                      aliases: [s: :start, e: :end, S: :src, d: :dest, u: :update_tags]
                    )
    :ok
  end

end
