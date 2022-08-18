defmodule GenChatting.ChattingRoomSupervisor do
  use DynamicSupervisor

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one, max_seconds: 1, max_restarts: 1_000)
  end

  def create_room(room_name) do
    spec = {GenChatting.ChattingRoom, room_name: room_name}
    {:ok, _pid} = DynamicSupervisor.start_child(__MODULE__, spec)
  end
end
