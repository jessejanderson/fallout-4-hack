# Fallout

**TODO: Add tests (so much for TDD)**
- Add Tests (so much for TDD)
- Fix CLI Help docs

## Run at Command Line
Run `./fallout ` followed by the 8 words available for your hack.

Example: `./fallout bat cat bar car bob cob but cut`

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add fallout to your list of dependencies in `mix.exs`:

        def deps do
          [{:fallout, "~> 0.0.1"}]
        end

  2. Ensure fallout is started before your application:

        def application do
          [applications: [:fallout]]
        end
