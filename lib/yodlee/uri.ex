defmodule Yodlee.URI do

  defmacro __using__(_) do
    quote do
      defp build_url(ext \\ "") do
        if ext != "", do: ext = "/" <> ext

        @base <> ext
      end
    end
  end

  def encode_query(list) do
    Enum.map_join list, "&", fn x ->
      pair(x)
    end
  end

  defp pair({key, value}) do
    cond do
      is_map(value) ->
        Enum.map_join value, "&", fn {k, v} ->
          pair({"#{key}.#{k}", v})
        end
      is_list(value) ->
        vals = Enum.map(Enum.with_index(value), fn {k, v} -> {v, k} end)
        Enum.map_join vals, "&", fn {k, v} ->
          pair({"#{key}[#{k}]", v})
        end
      true ->
        vv = value |> to_string |> URI.encode
        kk = key |> to_string |> URI.encode
        "#{kk}=#{vv}"
    end
  end
end
