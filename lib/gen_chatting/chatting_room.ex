defmodule GenChatting.ChattingRoom do
  use GenServer

  def start_link(room_name) do
    GenServer.start_link(__MODULE__, [], name: room_name[:room_name])
  end

  def enter({room_name, client_pid}) do
    GenServer.cast(room_name, {:enter, client_pid})
  end

  def send({room_name, message}) do
    GenServer.cast(room_name, {:send, message})
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_cast({:enter, client_pid}, state) do
    case Enum.find_value(state, fn x -> x == client_pid end) do
      nil -> {:noreply, [client_pid | state]}
      true -> {:noreply, state}
    end
  end

  @impl true
  def handle_cast({:send, message}, state) do
    Enum.each(state, fn pid -> send(pid, "#{inspect(pid)} : #{message}") end)
    {:noreply, state}
  end
end
