defmodule GenChatting.ChattingServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def send(room_name, message) do
    GenServer.cast(__MODULE__, {:send, room_name, message})
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_cast({:send, room_name, message}, state) do
    GenChatting.ChattingRoom.broad_cast_message(room_name, message)
    {:noreply, state}
  end
end
