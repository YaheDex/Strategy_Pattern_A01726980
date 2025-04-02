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

defmodule Client1 do
  defstruct interested_products: []

  def new(shop) do
    client = %Client1{interested_products: [:product1]}
    shop = shop |> Subject.register_observer(client)
    {shop, client}
  end

  defimpl Observer do
    def update(%Client1{interested_products: interests}, product1, product2, product3) do
      if :product1 in interests do
        IO.puts("Client1 is interested in product1. New amount: #{product1}")
      end
    end
  end
end

defmodule Client2 do
  defstruct interested_products: []

  def new(shop) do
    client = %Client2{interested_products: [:product2]}
    shop = shop |> Subject.register_observer(client)
    {shop, client}
  end

  defimpl Observer do
    def update(%Client2{interested_products: interests}, product1, product2, product3) do
      if :product2 in interests do
        IO.puts("Client2 is interested in product2. New amount: #{product2}")
      end
    end
  end
end

defmodule Client3 do
  defstruct interested_products: []

  def new(shop) do
    client = %Client3{interested_products: [:product3]}
    shop = shop |> Subject.register_observer(client)
    {shop, client}
  end

  defimpl Observer do
    def update(%Client3{interested_products: interests}, product1, product2, product3) do
      if :product3 in interests do
        IO.puts("Client3 is interested in product3. New amount: #{product3}")
      end
    end
  end
end

# Initialize shop and clients
shop = %Shop{}
{shop, client1} = Client1.new(shop)
{shop, client2} = Client2.new(shop)
{shop, client3} = Client3.new(shop)

# Update products in the shop
shop = Shop.set_products(shop, 10, 20, 30)
