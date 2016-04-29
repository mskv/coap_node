defmodule CoapNode.Supervisor do
  use Supervisor

  @name CoapNode.Supervisor

  def start_link(port) do
    Supervisor.start_link(__MODULE__, port, name: @name)
  end

  def init(port) do
    children = [
      supervisor(CoapNode.ServerSupervisor, [port]),
      worker(Coap.Storage, [[], []])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
