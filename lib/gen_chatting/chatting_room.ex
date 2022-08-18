defmodule GenChatting.ChattingRoom do
  use GenServer

  def start_link(room_name) do
    GenServer.start_link(__MODULE__, [], name: room_name[:room_name])
  end

  def send({room_name, message}) do
    GenServer.cast(room_name, {:send, message})
  end

  @impl true
  def init(init_arg) do
    case GenChatting.ChattingRoomStatsh.get_chatting_room(self())  do
      nil -> {:ok, init_arg}
      restore_client -> IO.inspect(restore_client)
        {:ok, restore_client ++ init_arg}
    end
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

  # 이쪽에서 해당 프로세스의 이름을 넣고 싶음.
  @impl true
  def terminate(_reason, state) do
    GenChatting.ChattingRoomStatsh.restore_chatting_room({self(), %{ self() => state}})
  end
end
