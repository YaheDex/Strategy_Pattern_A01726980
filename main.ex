# Define protocols for behaviors
defprotocol WeaponBehavior do
  @doc "Defines the attack behavior"
  def attack(behavior)
end

defprotocol MoveBehavior do
  @doc "Defines the movement behavior"
  def move(behavior)
end

# Implement different weapon behaviors
defmodule Sword do
  defstruct []

  defimpl WeaponBehavior do
    def attack(_behavior), do: "Ataca con una espada."
  end
end

defmodule Bow do
  defstruct []

  defimpl WeaponBehavior do
    def attack(_behavior), do: "Dispara una flecha con un arco."
  end
end

defmodule Axe do
  defstruct []

  defimpl WeaponBehavior do
    def attack(_behavior), do: "Golpea con un hacha."
  end
end

# Implement different movement behaviors
defmodule Run do
  defstruct []

  defimpl MoveBehavior do
    def move(_behavior), do: "Corre rápidamente."
  end
end

defmodule Walk do
  defstruct []

  defimpl MoveBehavior do
    def move(_behavior), do: "Camina."
  end
end

defmodule Teleport do
  defstruct []

  defimpl MoveBehavior do
    def move(_behavior), do: "Se teletransporta instantáneamente."
  end
end

# Define the base Character module
defmodule Character do
  defmacro __using__(_opts) do
    quote do
      defstruct weapon_behavior: nil, move_behavior: nil

      def new(weapon_behavior, move_behavior) do
        %__MODULE__{weapon_behavior: weapon_behavior, move_behavior: move_behavior}
      end

      def perform_attack(%__MODULE__{weapon_behavior: weapon_behavior}) do
        WeaponBehavior.attack(weapon_behavior)
      end

      def perform_move(%__MODULE__{move_behavior: move_behavior}) do
        MoveBehavior.move(move_behavior)
      end

      def set_weapon_behavior(character, new_weapon_behavior) do
        %__MODULE__{character | weapon_behavior: new_weapon_behavior}
      end

      def set_move_behavior(character, new_move_behavior) do
        %__MODULE__{character | move_behavior: new_move_behavior}
      end

      def show_character(), do: "Este es un personaje."

      def display(), do: "Soy un personaje genérico."
    end
  end
end

# Warrior class extending Character
defmodule Warrior do
  use Character

  def display(), do: "Soy un guerrero."
end

# Archer class extending Character
defmodule Archer do
  use Character

  def display(), do: "Soy un arquero."
end

# Main Execution
warrior = Warrior.new(%Sword{}, %Run{})
IO.puts(Warrior.display())  # Output: Soy un valiente guerrero.
IO.puts(Warrior.perform_attack(warrior))  # Output: Ataca con una espada.
IO.puts(Warrior.perform_move(warrior))  # Output: Corre rápidamente.

# Change behaviors dynamically
warrior = Warrior.set_weapon_behavior(warrior, %Axe{})
warrior = Warrior.set_move_behavior(warrior, %Walk{})

IO.puts("\nDespués de cambiar comportamientos:")
IO.puts(Warrior.perform_attack(warrior))  # Output: Golpea con un hacha.
IO.puts(Warrior.perform_move(warrior))  # Output: Camina a paso moderado.

IO.puts("\n---\n")

archer = Archer.new(%Bow{}, %Teleport{})
IO.puts(Archer.display())  # Output: Soy un arquero preciso.
IO.puts(Archer.perform_attack(archer))  # Output: Dispara una flecha con un arco.
IO.puts(Archer.perform_move(archer))  # Output: Se teletransporta instantáneamente.
