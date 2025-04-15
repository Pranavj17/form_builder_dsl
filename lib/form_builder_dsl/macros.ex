defmodule FormBuilderDsl.Macros do
  def formatter_macros do
    [
      form: 2,
      defenum: 2,
      text: 1,
      text: 2,
      select: 1,
      select: 2,
      date_time: 1,
      date_time: 2
    ]
  end
end
