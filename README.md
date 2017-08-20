# Identicon

**Elixir playground**

This application was written for training purposes. 
It's generating random GitHub-like avatar .png file basing on string input. 

* Image is built on 5x5 grid. 
* Color is based on the string input.
* The same string will always produce the same result.
* The project is using few Erlang libs, like :egd, :crypto or :binary. 

Example file generated for "string" ;)

![alt text](https://raw.githubusercontent.com/Kociamber/identicon/master/string.png "string.png")

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `identicon` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:identicon, "~> 0.1.0"}]
end
```
