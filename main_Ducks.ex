defprotocol FlyBehavior do
    @doc "Defines the fly behavior"
    def fly(behavior)
  end

  defprotocol QuackBehavior do
    @doc "Defines the quack behavior"
    def quack(behavior)
  end

  defmodule FlyNoWay do
    defstruct []

    defimpl FlyBehavior do
      def fly(_behavior), do: "No puedo volar."
    end
  end

  defmodule FlyWithWings do
    defstruct []

    defimpl FlyBehavior do
      def fly(_behavior), do: "Estoy volando con alas."
    end
  end

  defmodule FlyWithBalloon do
    defstruct []

    defimpl FlyBehavior do
      def fly(_behavior), do: "Estoy volando con un globo."
    end
  end

  defmodule Quack do
    defstruct []

    defimpl QuackBehavior do
      def quack(_behavior), do: "¡Quack!"
    end
  end

  defmodule MuteQuack do
    defstruct []

    defimpl QuackBehavior do
      def quack(_behavior), do: "..."
    end
  end

  defmodule Duck do
    defmacro __using__(_opts) do
      quote do
        defstruct fly_behavior: nil, quack_behavior: nil

        def new(fly_behavior, quack_behavior) do
          %__MODULE__{fly_behavior: fly_behavior, quack_behavior: quack_behavior}
        end

        def perform_fly(%__MODULE__{fly_behavior: fly_behavior}) do
          FlyBehavior.fly(fly_behavior)
        end

        def perform_quack(%__MODULE__{quack_behavior: quack_behavior}) do
          QuackBehavior.quack(quack_behavior)
        end

        def set_fly_behavior(duck, new_fly_behavior) do
          %__MODULE__{duck | fly_behavior: new_fly_behavior}
        end

        def set_quack_behavior(duck, new_quack_behavior) do
          %__MODULE__{duck | quack_behavior: new_quack_behavior}
        end

        def swim(), do: "Todos los patos flotan, incluso los de juguete."

        def display(), do: "Soy un pato genérico."
      end
    end
  end

  defmodule MallardDuck do
    use Duck

    def display(), do: "Soy un pato silvestre Mallard."
  end

  # Main Execution
  mallard = MallardDuck.new(%FlyWithWings{}, %Quack{})
  IO.puts(MallardDuck.display())  # Output: Soy un pato silvestre Mallard.
  IO.puts(MallardDuck.perform_fly(mallard))  # Output: Estoy volando con alas.
  IO.puts(MallardDuck.perform_quack(mallard))  # Output: ¡Quack!

  # Change behaviors dynamically
  mallard = MallardDuck.set_fly_behavior(mallard, %FlyWithBalloon{})
  mallard = MallardDuck.set_quack_behavior(mallard, %MuteQuack{})

  IO.puts("\nDespués de cambiar comportamientos:")
  IO.puts(MallardDuck.perform_fly(mallard))  # Output: Estoy volando con un globo.
  IO.puts(MallardDuck.perform_quack(mallard))  # Output: ...
