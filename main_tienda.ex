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

defmodule Shop do
  use Subject

  defstruct [:product1, :product2, :product3, observers: []]

  def set_products(%__MODULE__{} = shop, product1, product2, product3) do
    shop = %__MODULE__{shop | product1: product1, product2: product2, product3: product3}
    notify_observers(shop, product1, product2, product3)
    shop
  end
end
