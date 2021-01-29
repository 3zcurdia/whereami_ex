defmodule Whereami do
  @moduledoc """
  Documentation for `Whereami`.
  """

  def geo_info(%{query_params: params} = conn) do
    params
    |> Map.get("ip", request_ip(conn))
    |> Whereami.GeoServer.fetch()
  end

  defp request_ip(%{remote_ip: remote_ip}) do
    remote_ip
    |> Tuple.to_list()
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(".")
  end
end
