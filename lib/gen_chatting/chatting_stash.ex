defmodule GenChatting.ChattingStash do
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def save_chatting({room_name, message}) do
    Agent.update(__MODULE__, fn map ->
      Map.update(map, room_name, message, fn existing_message -> [message | existing_message] end)
    end)
  end

  def get_chatting(room_name) do
    Agent.get(__MODULE__, fn map -> map[room_name] end)
  end
end
