defmodule Whereami.GeoServer do
  @moduledoc """
  It stores local stored reports as source of truth
  """
  require Logger
  use GenServer
  alias Whereami.{Bucket, IpInfo}

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def fetch(ip) do
    GenServer.call(__MODULE__, {:fetch, ip})
  end

  # Callbacks
  @impl true
  def init(state) do
    Bucket.start_link(state)
  end

  @impl true
  def handle_call({:fetch, ip}, _from, bucket) do
    case Bucket.get(bucket, ip) do
      nil ->
        {:reply, geo(bucket, ip), bucket}

      data ->
        {:reply, data, bucket}
    end
  end

  defp geo(bucket, ip) do
    case IpInfo.geo(ip) do
      {:ok, data} ->
        Bucket.put(bucket, ip, data)
        data

      {:error, msg} ->
        Logger.error("#{__MODULE__}: #{msg}")
        msg
    end
  end
end
