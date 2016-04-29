defmodule CoapNode.Mixfile do
  use Mix.Project

  @default_port 5683

  def project do
    [app: :coap_node,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [
      applications: [:logger],
      mod: {CoapNode, port},
      env: [coap_port: port, registry_endpoint: 'coap://127.0.0.1:5683/registry']
    ]
  end

  defp deps do
    [
      {:gen_coap, git: "https://github.com/gotthardp/gen_coap.git"},
      {:coap, git: "https://github.com/mskv/coap.git"}
    ]
  end

  defp port do
    if port = System.get_env("COAP_PORT") do
      case Integer.parse(port) do
        {port, ""} -> port
        _ -> @default_port
      end
    else
      @default_port
    end
  end
end
