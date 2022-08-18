defmodule GenChatting.ChattingServer do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def enter(room_name) do
    GenServer.call(__MODULE__, {:enter, room_name})
  end

  @impl true
  def init(init_arg) do
    case GenChatting.ChattingRoomStatsh.get_chatting_room() do
      %{} -> {:ok, init_arg}
      restore_chatting_room -> {:ok, restore_chatting_room}
    end
  end

  @impl true
  def handle_call({:enter, room_name}, from, state) do
    client_pid = elem(from, 0)

    case Map.has_key?(state, room_name) do
      false -> GenChatting.ChattingRoomSupervisor.create_room(room_name)
      _ -> true
    end

    GenServer.cast(room_name,{:enter,client_pid})

    state =
      Map.update(state, room_name, [client_pid], fn existing_value_ ->
        [client_pid | existing_value_]
      end)

    {:reply, room_name, state}
  end

  @impl true
  def terminate(_reason, state) do
    GenChatting.ChattingRoomStatsh.restore_chatting_room(state)
  end
end
