defmodule Chipper do
  @moduledoc """
  Documentation for Chipper.
  """

  @doc """
  Entry point for CLI tool.

  ## Examples

      iex> Chipper.main()
      :ok
      iex> Chipper.main(["-h"])
      :ok
      iex> Chipper.main(["-?"])
      :ok
      iex> Chipper.main(["foo"])
      :ok
      iex> Chipper.main(["-x"])
      :error

  """
  @spec main([binary()]) :: atom()
  def main(args \\ []) do
    {opts, args, invalid_opts} = OptionParser.parse(
                                   args,
                                   strict: [help: :boolean],
                                   aliases: [{:h, :help}, {String.to_atom("?"), :help}]
                                 )
    main(opts, args, invalid_opts)
  end

  @spec main([{atom(), any()}], [binary()], [{atom(), any()}]) :: atom()
  defp main(_opts, _args, []) do
    :ok
  end
  defp main(_, _, invalid_opts), do: usage(invalid_opts)

  @spec usage([{atom(), any()}]) :: atom()
  defp usage(invalid_opts) do
    IO.puts :stderr, "invalid options: #{inspect invalid_opts}"
    IO.puts :stderr, """
    Usage: chipper
    """
    :error
  end
end
