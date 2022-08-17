defmodule GenChattingTest do
  use ExUnit.Case
  doctest GenChatting

  test "greets the world" do
    assert GenChatting.hello() == :world
  end
end
