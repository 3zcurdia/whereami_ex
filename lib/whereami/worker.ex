defmodule Whereami.Worker do
  @moduledoc """
  It stores local stored reports as source of truth
  """
  require Logger
  use GenServer
  alias Whereami.IpInfo

  @table :data_cache

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def find(ip) do
    GenServer.call(__MODULE__, {:find, ip})
  end

  # Callbacks
  @impl true
  def init(state) do
    :ets.new(@table, [
      :set,
      :named_table,
      :protected,
      read_concurrency: true,
      write_concurrency: true
    ])

    {:ok, state}
  end

  @impl true
  def handle_call({:find, ip}, _from, state) do
    case :ets.lookup(@table, ip) do
      [{_key, data} | _] ->
        {:reply, {:ok, data}, state}

      _ ->
        {:reply, fetch(ip), state}
    end
  end

  defp fetch(ip) do
    case IpInfo.find(ip) do
      {:ok, data} ->
        :ets.insert(@table, {ip, data})
        {:ok, data}

      {:error, msg} ->
        Logger.error("#{__MODULE__}: #{msg}")
        {:error, msg}
    end
  end
end
