defmodule Whereami.Worker do
  @moduledoc """
  It stores local stored reports as source of truth
  """
  require Logger
  use GenServer
  alias Whereami.{Bucket, IpInfo}

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def find(ip) do
    GenServer.call(__MODULE__, {:find, ip})
  end

  # Callbacks
  @impl true
  def init(state) do
    Bucket.start_link(state)
  end

  @impl true
  def handle_call({:find, ip}, _from, bucket) do
    case Bucket.get(bucket, ip) do
      nil ->
        {:reply, fetch(bucket, ip), bucket}

      data ->
        {:reply, {:ok, data}, bucket}
    end
  end

  defp fetch(bucket, ip) do
    case IpInfo.find(ip) do
      {:ok, data} ->
        Bucket.put(bucket, ip, data)
        {:ok, data}

      {:error, msg} ->
        Logger.error("#{__MODULE__}: #{msg}")
        {:error, msg}
    end
  end
end
