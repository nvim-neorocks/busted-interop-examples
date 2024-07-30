# 🌖🧪 busted interop examples

Examples for combining Neovim/Lua test frameworks with busted

## Summary

We advocate for using luarocks and [busted](https://lunarmodules.github.io/busted/)
for testing, primarily for the following reasons:

- **Familiarity:**
  It is the de facto tried and tested standard in the Lua community,
  with a familiar API modeled after [rspec](https://rspec.info/).
- **Consistency:**
  Having a consistent API makes life easier for
    - Contributors to your project.
    - Package managers, who [run test suites](https://github.com/NixOS/nixpkgs/blob/7feaafb5f1dea9eb74186d8c40c2f6c095904429/pkgs/development/lua-modules/overrides.nix#L581)
    to ensure they don't deliver a broken version of your plugin.
- **Better reproducibility:**
  By using luarocks to manage your test dependencies, you can easily
  pin them. Checking out git repositories is prone to flakes in CI
  and "it works on my machine" issues.

We do, however, acknowledge that some plugin authors may have additional requirements.
For example, something that is not easy with our recommended busted setup is process isolation.

Fortunately, other test frameworks are available on luarocks and can be combined with
(and run from within) busted.

> [!TIP]
>
> If you find yourself limited due to a lack of process isolation,
> first consider rethinking your architecture.
> 
> A well-designed code base keeps its core logic as pure as possible,
> which makes it easy to reason about and easy to test.
> Side-effects (IO, environment, state, ...) should be "woven in" through an interface[^1].

[^1]: This can be done easily, without having to understand monads
      (see for example [the Universal Architecture](https://fullstackradio.com/38)).
      Nevertheless, in some cases (especially when it comes to UI),
      it can be challenging.

## Prerequisites

We assume you are familiar with our recommended method for running tests with busted.
If not, here are some resources to get you started:

- [neovim-lua-plugin-template](https://github.com/nvim-lua/nvim-lua-plugin-template)
  (Neovim plugin template)
- [nvim-busted-action](https://github.com/nvim-neorocks/nvim-busted-action)
  (GitHub Actions workflow)
- [nlua](https://github.com/mfussenegger/nlua)
  (library)
- [Testing Neovim plugins with Busted](https://hiphish.github.io/blog/2024/01/29/testing-neovim-plugins-with-busted/)
  (blog post)

## Frameworks that work with busted out of the box

- [`nvim-nio`](https://github.com/nvim-neotest/nvim-nio)
  The [`nio.tests`](https://github.com/nvim-neotest/nvim-nio?tab=readme-ov-file#niotests)
  module provides async versions of busted's test functions.

## Examples for making other frameworks interoperable with busted

The following examples have not been designed with busted interoperability in mind,
but can still be combined with busted.

- [`mini.test`](./mini.test)

TODO:

- [ ] [`nvim-test`](https://github.com/lewis6991/nvim-test) (needs triage)
