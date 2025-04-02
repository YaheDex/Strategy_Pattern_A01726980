# Subject module
defmodule Subject do
  defmacro __using__(_) do
    quote do
      defstruct observers: []

      def register_observer(%__MODULE__{observers: observers} = subject, observer) do
        %__MODULE__{subject | observers: observers ++ [observer]}
      end

      def notify_observers(%__MODULE__{observers: observers}, product1, product2, product3) do
        Enum.each(observers, fn observer ->
          observer.update(product1, product2, product3)
        end)
      end
    end
  end
end

# Observer protocol
defprotocol Observer do
  @doc "Defines the update method for observers."
  def update(observer, product1, product2, product3)
end
