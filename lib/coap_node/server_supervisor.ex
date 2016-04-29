defmodule CoapNode.ServerSupervisor do
  def start_link(port) do
    Supervisor.start_link(:coap_server, [port])
  end
end
