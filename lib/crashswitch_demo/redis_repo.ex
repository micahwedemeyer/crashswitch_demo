defmodule CrashswitchDemo.RedisRepo do

  def defaultclient do
    Exredis.Api.defaultclient
  end
end
