defmodule GenChatting.ChattingRoom do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{}  , name: __MODULE__)
  end

  def enter(room_name) do
    GenServer.call(__MODULE__, {:enter, room_name})
  end

  def broad_cast_message(room_name, message) do
    GenServer.cast(__MODULE__, {:broad_cast, room_name, message})
  end

  @impl true
  def init(init_arg) do
    {:ok, init_arg}
  end

  @impl true
  def handle_call({:enter, room_name}, from, state) do
    state = Map.update(state, room_name, [from], fn existing_value -> [from | existing_value] end)
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:broad_cast, room_name, message}, state) do
    state[room_name]
    |> Enum.each(fn pid -> send(elem(pid,0) , "#{inspect(elem(pid,0))} : #{message}" ) end)

    {:noreply, state}
  end
end
