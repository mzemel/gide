defmodule Kafka.Offset do
  use GenServer

  @moduledoc """
  This module is designed to keep a persistent state of the Kafka offset
  """


  #####
  # External API

  def start_link(initial_offset) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, initial_offset, name: __MODULE__)
  end

  def get_offset do
    GenServer.call(__MODULE__, :get_offset)
  end

  def update_offset(new_offset) do
    GenServer.call(__MODULE__, {:update_offset, new_offset})
  end

  def increase do
    GenServer.call(__MODULE__, :increase)
  end

  #####
  # GenServer Implementation

  def handle_call(:get_offset, _from, current_offset) do
    { :reply, current_offset, current_offset }
  end

  def handle_call({:update_offset, new_offset}, _from, _current_offset) do
    { :reply, new_offset, new_offset }
  end

  def handle_call(:increase, _from, current_offset) do
    { :reply, current_offset + 1, current_offset + 1}
  end

end