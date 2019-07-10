defmodule DbSuper do
  use Supervisor

  @doc """
  We must define start_link/1 because the child_spec/1(import by use Supervisor) asked
  this.
  Also, to start a module based supervisor we must user Supervisor.start_link(arg1, arg2, arg3)
  """
  def start_link(args) do
    Supervisor.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc """
  We must implement this to create the child spec for supervisor
  """
  @impl true
  def init(_) do
    children = [
      %{Agent.child_spec(fn -> 2 end) | id: {Agent,2}},
      %{Agent.child_spec(fn -> 1 end) | id: {Agent,1}}
    ]
    Supervisor.init(children, strategy: :one_for_one)
  end
end
