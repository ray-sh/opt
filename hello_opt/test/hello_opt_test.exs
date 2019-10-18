defmodule HelloOptTest do
  use ExUnit.Case
  doctest HelloOpt

  test "greets the world" do
    assert HelloOpt.hello() == :world
  end

  @doc """
  The map child spec is the most powerful syntax but its' not easy to write
  """
  test "create supervisor tree with childspec map" do
    children = [
      %{
        id: {Agent,1},
        start: {Agent, :start_link, [fn -> 2 end, [name: Agent1]]}
      },
      %{
        id: {Agent,2},
        start: {Agent, :start_link, [fn -> 3 end, [name: Agent2]]}
      }
    ]
    {:ok,_} = Supervisor.start_link(children, strategy: :one_for_one, name: TestSup)
    Supervisor.count_children(TestSup) |> IO.inspect()
    Supervisor.which_children(TestSup) |> IO.inspect()
    assert Agent.get(Agent1, fn state -> state end) == 2
  end

  @doc """
  child spec defined how the child been start/restart/stop, usually it's defined within the child module
  by function child_spec/1, the final goal of child_spec is used to replace the map child spec, usualy it
  only contains one parameter which will has some limits

  where is child spec
  1>Defined explict within the module
  2>Import from other module by using "use", for example: "use GenServer, restart: :transient"
  """
  test "child spec" do
    children = [
      {Agent, fn -> 2 end}, # It will call Agent.child_spec(fn ->2 end)
      %{Agent.child_spec(fn -> 3 end) | id: {Agent,2}},

      #method to update child spec map, we should use the previsous way
      #which is much easier to read
      Supervisor.child_spec(Stack, id: {Agent, 6}),
      Stack # It equals {Stack, []}
    ]
    {:ok,_} = Supervisor.start_link(children, strategy: :one_for_one, name: TestSup)
    Supervisor.which_children(TestSup) |> IO.inspect()
  end

<<<<<<< HEAD

  @doc """
      sup
  /         \
  DynamicSup   Worker
  """
  test "create supervisor tree with empty children" do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: MyApp.DynamicSupervisor},
      {Agent, fn -> 3 end}
    ]

    Supervisor.start_link(children, strategy: :one_for_one)

    {:ok, child} = DynamicSupervisor.start_child(MyApp.DynamicSupervisor, Agent.child_spec(fn -> 2 end))
    assert Agent.get(child, fn state -> state end) == 2
=======
  @doc """
  Supervisor tree and module based supervisor
  A module-based supervisor gives you more direct control over how the supervisor is initialized
       RootSup
      /       \
    Sup1       Worker3
    /     \
  Worker1  Worker2
  """
  test "supervisor tree" do
    children = [
      DbSuper,
      %{Agent.child_spec(fn -> 3 end) | id: {Agent,3}}
    ]
    {:ok,_} = Supervisor.start_link(children, strategy: :one_for_one, name: TestSup)
    Supervisor.which_children(TestSup) |> IO.inspect()
>>>>>>> 78a6894e88f92d9002b928d63b2d0d5b252d2749
  end



end
