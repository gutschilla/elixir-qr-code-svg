defmodule QrCodeSvg do
  @moduledoc """
  Creates a simple SVG out of the bytes that QRCode creates.
  """

  @doc """
  Encodes a string, returns a string containing an SVG.

  Accepts ecc (error correction) mode as parameter (defaults to 'M'), can be

  - 'L':  7% lost data recovery
  - 'M': 15%
  - 'Q': 25% (doesn't always work)
  - 'H': 30% (often fails)

  ## Examples

      iex> QrCodeSvg.encode("Hi!", 'L')
      ""

  """
  def encode(string, ecc \\ 'M') do
    reducer = fn_reducer()
    string
    |> qr_encode(ecc)
    |> String.split("")
    |> Enum.reduce({"", 0, 0}, reducer)
    |> wrap()
  end

  # this is QRCode.as_string() with ecc support. PR is pending
  defp qr_encode(string, ecc) do
    %QRCode{data: data, dimension: dimension} = QRCode.encode(string, ecc)
    data
    |> to_chars()
    |> Enum.chunk_every(dimension)
    |> Enum.join("\n")
    |> (fn s -> s <> "\n" end).()
  end

  # this is 1:1 from QRCode.to_chars().
  defp to_chars(list), do: to_chars(list, [])
  defp to_chars(<< 0 :: size(1), tail :: bitstring >>, acc), do: to_chars(tail, ["." | acc])
  defp to_chars(<< 1 :: size(1), tail :: bitstring >>, acc), do: to_chars(tail, ["#" | acc])
  defp to_chars(<<>>, acc), do: Enum.reverse(acc)

  def fn_reducer do
    fn
      "#",  {svg,  x, y} -> {svg <> ~s[<rect x="#{x}" y="#{y}" width="1" height="1" fill="black"/>\n], x + 1, y};
      "\n", {svg, _x, y} -> {svg,     0, y + 1};
      ".",  {svg,  x, y} -> {svg, x + 1, y};
      _,    {svg,  x, y} -> {svg, x,     y}
    end
  end

  def wrap({rects, _x, y}) do
    """
    <svg xmlns="http://www.w3.org/2000/svg"
    version="1.1" baseProfile="full"
    width="#{y}" height="#{y}" viewBox="0 0 #{y} #{y}">
    #{rects}
    </svg>
    """
  end
end
