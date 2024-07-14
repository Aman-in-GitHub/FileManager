defmodule Exit do
  @moduledoc """
  Exits the program
  """

  def exit() do
    Enum.each(1..3, fn i ->
      ProgressBar.render(i, 3,
        bar: "-",
        left: "",
        right: " Terminating",
        bar_color: [IO.ANSI.black(), IO.ANSI.red_background()],
        width: 30
      )

      :timer.sleep(1000)
    end)

    System.halt(1)
  end
end
