defmodule CrashswitchDemo.PageController do
  use CrashswitchDemo.Web, :controller
  alias CrashswitchDemo.RedisRepo

  def index(conn, _params) do
    case RedisRepo.defaultclient |> Exredis.query(["GET", "crashed"]) do
      :undefined ->
        conn
        |> put_status(:ok)
        |> render("index.html", crashed: false)
      crash_code ->
        {code, _} = Integer.parse(crash_code, 10)
        conn 
        |> put_status(code)
        |> put_layout(false)
        |> render("#{code}.html")
    end
  end

  def crash(conn, %{"crashed" => crash_params}) do
    code = crash_params["status_code"]
    duration = crash_params["duration"]

    RedisRepo.defaultclient |> Exredis.query ["SET", "crashed", code]
    RedisRepo.defaultclient |> Exredis.query ["EXPIRE", "crashed", duration]

    conn
    |> redirect(to: page_path(conn, :index))
  end
end
