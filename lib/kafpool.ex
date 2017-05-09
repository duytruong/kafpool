defmodule Kafpool do
  @doc """
  Produce a message to Kafka.

  ## Examples

      iex> Kafpool.produce("hello from Kafpool")
      :ok

  """
  def produce(msg) do
    :poolboy.transaction(Kafpool.Application.pool_name(), fn(pid) -> Kafpool.Worker.produce(pid, msg) end)
  end
end
