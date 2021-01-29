defmodule Whereami.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "{ 'hello' : 'world!' }")
  end

  match _ do
    send_resp(conn, 404, "Oops!")
  end
end
