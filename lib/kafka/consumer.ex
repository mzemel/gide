defmodule Kafka.Consumer do
  use GenServer

  alias Gide.Audit

  #####
  # External API

  def start_link do
    {:ok, _pid} = GenServer.start_link(__MODULE__, Kafka.Offset, name: __MODULE__)
  end

  @doc ~S"""
  Save audit and increase offset

  ### Examples

      iex> message = %{value: "{\"event\":\"some content\",\"fk_guid\":\"f660f417-6c2c-458d-8c31-03a366134b0c\",\"ip\":\"some content\"}"}
      iex> Kafka.Consumer.save(message)
      {:ok, :successful_write}
  """
   def save(message) do
    Kafka.Offset.increase

    message
    |> to_changeset
    |> Gide.Repo.insert
    |> handle_insert(message)
  end

  defp handle_insert({:ok, _}, _), do: {:ok, :successful_write}
  defp handle_insert({:error, response}, message) do
    response.errors
    |> Enum.into(%{}) 
    |> to_error_json(message) 
    |> produce("failed_audits")
  end

  @doc ~S"""
  Decode Kafka message to a valid or invalid Ecto changeset

  ### Examples

      iex> message = %{value: "{\"event\":\"User logged in\"}"}
      iex> Kafka.Consumer.to_changeset(message)
      Gide.Audit.changeset(%Gide.Audit{}, %{event: "User logged in"})

  Nonprintable binaries due to GZip compression will be converted to an empty changeset

      iex> message = %{value: <<204, 204, 103, 42>>}
      iex> Kafka.Consumer.to_changeset(message)
      Gide.Audit.changeset(%Gide.Audit{}, %{})
  """
  def to_changeset(message) do
    JSX.decode(message.value) |> handle_decode
  end

  defp handle_decode({:error, _}), do: Audit.changeset(%Audit{}, %{})
  defp handle_decode({:ok, decode}), do: Audit.changeset(%Audit{}, decode)

  @doc ~S"""
  Encode errors and original kafka message in JSON

  ### Examples

      iex> message = %{value: "{\"event\":\"some content\",\"ip\":\"some content\"}"}
      iex> Kafka.Consumer.to_error_json(%{fk_guid: "cannot be blank"}, message)
      "{\"errors\":{\"fk_guid\":\"cannot be blank\"},\"original_message\":\"{\\\"event\\\":\\\"some content\\\",\\\"ip\\\":\\\"some content\\\"}\"}"

  Nonprintable binaries due to GZip compression will be converted to "Unprocessable string"

      iex> message = %{value: <<204, 204, 103, 42>>}
      iex> Kafka.Consumer.to_error_json(%{fk_guid: "cannot be blank"}, message)
      "{\"errors\":{\"fk_guid\":\"cannot be blank\"},\"original_message\":\"Unprocessable string\"}"

  """
  def to_error_json(errors, message) do
    original_message = if String.printable?(message.value), do: message.value, else: "Unprocessable string"
    JSX.encode!(%{errors: errors, original_message: original_message})
  end

  @doc ~S"""
  Produce JSON message to Kafka
  """
  def produce(message, topic \\ "failed_audits") do
    KafkaEx.produce(topic, 0, message) |> handle_produce
  end

  defp handle_produce(:ok), do: {:ok, :message_sent}
  defp handle_produce(_), do: {:error, :failed_to_send}

  #####
  # GenServer Implementation

  def init(_args) do
    KafkaEx.stream("audits", 0, offset: Kafka.Offset.get_offset)
    |> Enum.each(fn(msg) -> save msg end)
  end

end