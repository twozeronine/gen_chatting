defmodule GenChatting.ChattingRoomStatsh do
  use Agent
  def start_link(_init_args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def restore_chatting_room({room_name, room_map}) do
    Agent.update(__MODULE__, fn map ->
      Map.update(map, room_name, List.flatten(Map.values(room_map)) , fn existing_value ->
        Map.values(room_map) ++ existing_value
      end)
    end)
  end

  def get_chatting_room() do
    Agent.get(__MODULE__, fn map -> map end)
  end

  def get_chatting_room(room_name) do
    Agent.get(__MODULE__, fn map -> map[room_name] end)
  end
end
