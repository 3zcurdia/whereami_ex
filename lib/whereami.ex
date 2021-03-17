defmodule Whereami do
  @moduledoc """
  Documentation for `Whereami`.
  """

  @doc """
  It finds the geo info from a given IP in the query or in the remote_ip params
  """
  def find(conn) do
    conn
    |> fetch_ip
    |> Whereami.Worker.find()
  end

  defp fetch_ip(%{query_params: params, remote_ip: remote_ip}) do
    Map.get(params, "ip", tuple_to_string(remote_ip))
  end

  defp tuple_to_string(tuple) do
    tuple
    |> Tuple.to_list()
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(".")
  end
end
