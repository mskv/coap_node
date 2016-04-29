defmodule CoapNode.Resources.Switch do
  use Coap.Resource
  alias Coap.Storage

  def start(path, params) do
    Storage.set(path_to_string(path), false)
    super(path, params)
  end

  # gen_coap handlers

  def coap_get(_ch_id, prefix, _name, _query) do
    key = path_to_string(prefix)
    case Storage.get(key) do
      :not_found -> coap_content(payload: "not found")
      value -> coap_content(payload: key <> " " <> serialize_value(value))
    end
  end

  def coap_put(_ch_id, prefix, _name, content) do
    {:coap_content, _etag, _max_age, _format, payload} = content
    key = path_to_string(prefix)
    response = process_payload(key, payload)
    :coap_responder.notify(prefix, coap_content(payload: key <> " " <> serialize_value(response)))
    :ok
  end

  # private

  defp serialize_value(value) do
    cond do
      is_boolean(value) -> if(value, do: "on", else: "off")
      true -> value
    end
  end

  defp path_to_string(prefix) do
    Enum.join(prefix, "/")
  end

  defp process_payload(storage_key, payload) do
    case payload do
      "on" -> Storage.set(storage_key, true, true)
      "off" -> Storage.set(storage_key, false, true)
      "toggle" -> Storage.set(storage_key, fn(state) -> !state end, true)
      _ -> "not recognized"
    end
  end
end
