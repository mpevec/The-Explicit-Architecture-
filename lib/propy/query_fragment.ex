defmodule Propy.QueryFragment do
  @moduledoc """
  .
  """

  # Example: instead of:
  #   select: %{date: fragment("to_char(?, ?)", p.inserted_at, "YYYY-mm-dd")}
  # we can use this macro and then refactor:
  #   select: %{date: to_char(p.inserted_at, "YYYY-MM-DD")}
  defmacro to_char(field, format) do
    quote do
      fragment("to_char(?, ?)", unquote(field), unquote(format))
    end
  end

  # Example: instead of:
  #   fragment("?::date", ^from)
  # we can use this macro and then refactor:
  #   to_date(from)
  defmacro to_date(date) do
    quote do
      fragment("?::date", unquote(date))
    end
  end
end