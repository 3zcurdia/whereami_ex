defmodule Whereami.IpInfo do
  @moduledoc """
  It manages ipinfo.io geo api
  """

  @doc """
  Get geo info from a given ip adress

  ## Examples

      iex> Whereami.IpInfo.find("8.8.8.8")
      {:ok,
       %{
         "anycast" => true,
         "city" => "Mountain View",
         "country" => "US",
         "ip" => "8.8.8.8",
         "loc" => "37.4056,-122.0775",
         "postal" => "94043",
         "region" => "California",
         "timezone" => "America/Los_Angeles"
       }}

  """
  def find(ip_address) do
    ip_address
    |> url
    |> Tesla.get()
    |> decode
  end

  defp url(ip_address) do
    "https://ipinfo.io/#{ip_address}/geo"
  end

  defp decode({:ok, %{status: 200, body: body}}) do
    body
    |> Jason.decode()
    |> remove_readme
  end

  defp decode({:ok, response}), do: {:error, response}
  defp decode({:error, _msg} = error), do: error

  defp remove_readme({:ok, map}), do: {:ok, Map.delete(map, "readme")}
  defp remove_readme(any), do: any
end
