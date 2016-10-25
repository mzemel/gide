defmodule Kafka.Supervisor do
  use Supervisor

  @moduledoc """
  Starts the subsupervisor and offset processes
  """

  def start_link(initial_offset) do
    result = { :ok, sup } = Supervisor.start_link( __MODULE__, [])
    start_workers(sup, initial_offset)
    result
  end

  def start_workers(sup, initial_offset) do
    {:ok, offset_pid} = Supervisor.start_child(sup, worker(Kafka.Offset, initial_offset))
    Supervisor.start_child(sup, supervisor(Kafka.SubSupervisor, [offset_pid]))
  end

  def init(_) do
    supervise [], strategy: :one_for_one
  end
end
