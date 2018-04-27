defmodule Chipper do
  @moduledoc """
  Documentation for Chipper.
  """

  @doc """
  Entry point for CLI tool.

  ## Examples

      iex> Chipper.main()
      {:error, nil}
      iex> Chipper.main(["-h"])
      {:error, nil}
      iex> Chipper.main(["-?"])
      {:error, nil}
      iex> Chipper.main(["foo"])
      {:ok, []}
      iex> Chipper.main(["-x"])
      {:error, :invalid_opts}

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
  defp main(_opts, [filename | _remaining_args], []) do
    File.stream!(filename, [:raw, :read_ahead, :binary], 4096)
    |> Chipper.IFF.read
  end
  defp main(_opts, [], []), do: usage()
  defp main(_, _, invalid_opts), do: print_invalid_opts(invalid_opts)

  @spec print_invalid_opts([{atom(), any()}]) :: {atom(), any()}
  defp print_invalid_opts(invalid_opts) do
    IO.puts :stderr, "invalid options: #{inspect invalid_opts}"
    usage(:invalid_opts)
  end

  @spec usage(any()) :: {atom(), any()}
  defp usage(reason \\ nil) do
    IO.puts :stderr, """
    Usage: chipper
    """
    {:error, reason}
  end
end
