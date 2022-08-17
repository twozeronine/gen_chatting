defmodule GenChatting.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GenChatting.ChattingRoom,
      GenChatting.ChattingServer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [
      strategy: :one_for_one,
      max_seconds: 1,
      max_restarts: 1_000,
      name: GenChatting.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
