defmodule Stack do
  def child_spec(_) do
    %{Agent.child_spec(fn -> 1 end) | id: {Agent,5} }
  end
end
