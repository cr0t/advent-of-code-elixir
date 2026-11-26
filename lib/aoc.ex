defmodule AoC do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      # We can define such a module later and use in our solutions:
      # import AoC.Helpers
      @after_compile AoC
    end
  end

  # Runs the solution right after it compiles, so files need no footer.
  def __after_compile__(env, _bytecode),
    do: AoC.Runner.run(env.module, env.file)
end
