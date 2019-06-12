# QrCodeSvg

Creates a simple SVG out of the bytes that QRCode creates.

## QrCodeSvg.encode(string, ecc \\ 'M')

Encodes a string, returns a string containing an SVG.

Accepts ecc (error correction) mode as parameter (defaults to 'M'), can be

- 'L':  7% lost data recovery
- 'M': 15%
- 'Q': 25% (doesn't always work)
- 'H': 30% (often fails)

## Examples

```elixir
svg = QrCodeSvg.encode("Hey")
"<svg... ><rect../></svg>"
```

## Known bug

Due to a some unpleasantries in the underlying QRCode module, longer strings do
not work.

```elixir
QrCodeSvg.encode("http://foo.bar.baz")
```

Will throw up :-/



## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `qr_code_svg` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:qr_code_svg, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/qr_code_svg](https://hexdocs.pm/qr_code_svg).

