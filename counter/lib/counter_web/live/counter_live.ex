defmodule CounterWeb.CounterLive do
  use CounterWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, count: 0, step: 1)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <p>Hello</p>
    Count: <%= @count %>
    <button phx-click="increment">Increment</button>
    <button phx-click="start">Start</button>
    <button phx-click="stop">Stop</button>

    <.form let={f} for={%{}} phx-submit="increment_submit" phx-change="increment_change">
      <%= number_input f, :step, value: @step %>
      <%= submit "Submit" %>
    </.form>
    """
  end

  def handle_event("start", _params, socket) do
    Process.send(self(), "auto_increment", [])
    {:noreply, assign(socket, running: true)}
  end

  def handle_event("stop", _params, socket) do
    {:noreply, assign(socket, running: false)}
  end

  @impl true
  def handle_event("increment_change", params, socket) do
    step =
      case params["step"] do
        "" -> 0
        step -> String.to_integer(step)
      end

    {:noreply, assign(socket, :step, step)}
  end

  @impl true
  def handle_event("increment_submit", _params, socket) do
    {:noreply, assign(socket, count: socket.assigns.count + socket.assigns.step)}
  end

  @impl true
  def handle_event("increment", _params, socket) do
    {:noreply, assign(socket, :count, socket.assigns.count + socket.assigns.step)}
  end

  @impl true
  def handle_info("auto_increment", socket) do
    if socket.assigns.running do
      Process.send_after(self(), "auto_increment", 1000)
    end

    {:noreply, assign(socket, :count, socket.assigns.count + 1)}
  end
end
