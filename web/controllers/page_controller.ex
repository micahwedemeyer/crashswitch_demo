defmodule CrashswitchDemo.PageController do
  use CrashswitchDemo.Web, :controller

  def index(conn, _params) do
    {:ok, client} = Exredis.start_link
    
    case client |> Exredis.query ["GET", "crashed"] do
      :undefined ->
        conn
        |> put_status(:ok)
        |> render("index.html", crashed: false)
      crash_code ->
        {code, _} = Integer.parse(crash_code, 10)
        conn 
        |> put_status(code)
        |> render("index.html", crashed: true)
    end
  end

  def crash(conn, %{"crashed" => crash_params}) do
    {:ok, client} = Exredis.start_link

    code = crash_params["status_code"]
    duration = crash_params["duration"]

    client |> Exredis.query ["SET", "crashed", code]
    client |> Exredis.query ["EXPIRE", "crashed", duration]

    conn
    |> redirect(to: page_path(conn, :index))
  end
end
