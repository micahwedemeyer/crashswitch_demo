ExUnit.start

Mix.Task.run "ecto.create", ~w(-r CrashswitchDemo.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r CrashswitchDemo.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(CrashswitchDemo.Repo)

