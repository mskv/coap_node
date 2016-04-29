defmodule CoapNode do
  use Application

  def start(_type, port) do
    CoapNode.Supervisor.start_link(port)
  end
end
