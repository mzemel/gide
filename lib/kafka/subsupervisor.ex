defmodule Kafka.SubSupervisor do
  use Supervisor

  @moduledoc """
  Supervises the consumer process
  """

  def start_link(offset_pid) do
    {:ok, _pid} = Supervisor.start_link(__MODULE__, offset_pid)
  end

  def init(_offset_pid) do
    child_processes = [ worker(Kafka.Consumer, [])]
    supervise child_processes, strategy: :one_for_one
  end
end