defmodule ExSatori.Client do
  @moduledoc false 

  alias __MODULE__

  @doc """
  Returns a map wiht values that can be used to connect to a websocket.
  Expects that the argument is websocket URI in string format

  - protocol
  - host
  - port
  - path
  - query

  Example:

    iex> ExSatori.Client.parse("wss://open-data.api.satori.com")
    %{
      protocol: :wss,
      path: "/",
      port: 443,
      host: "open-data.api.satori.com",
      query: "/"
    }
    iex> ExSatori.Client.parse("")
    :error
    iex> ExSatori.Client.parse("http://www.reddit.com")
    :error
  """
  def parse(url) do
    case :http_uri.parse(url, [scheme_defaults: [ws: 80, wss: 443]]) do
      {:ok, {protocol, _, host, port, path, query}} ->
        %{protocol: protocol, host: host, port: port, path: path, query: path <> query}

      {:error, _} ->
        :error
    end
  end

  @doc """
  Determines the transport method

  Example:

    iex> ExSatori.Client.get_transport(:wss)
    :ssl
    iex> ExSatori.Client.get_transport(:ws)
    :gen_tcp
    iex> ExSatori.Client.get_transport(:http)
    :error

  """
  def get_transport(protocol) when protocol == :wss, do: :ssl
  def get_transport(protocol) when protocol == :ws, do: :gen_tcp
  def get_transport(_), do: :error

  def get_sock_reply({:ok, socket}), do: {:ok, socket}
end
