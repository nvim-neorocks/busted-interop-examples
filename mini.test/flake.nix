{
  description = "devShell for Neovim Lua plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neorocks.url = "github:nvim-neorocks/neorocks";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    flake-parts,
    neorocks,
    gen-luarc,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neorocks.overlays.default
            gen-luarc.overlays.default
          ];
        };
        luarc = pkgs.mk-luarc {
          nvim = pkgs.neovim-nightly;
          plugins = [
          ];
        };
        mini-test = pkgs.lua5_1.pkgs.callPackage 
          ({ buildLuarocksPackage, fetchurl, fetchzip, luaOlder }:
          buildLuarocksPackage {
            pname = "mini.test";
            version = "0.9.0-1";
            knownRockspec = (fetchurl {
              url    = "mirror://luarocks/mini.test-0.9.0-1.rockspec";
              sha256 = "0m4b36kpy0d5pj45gx5mv9x1dwdshzbwrssn35mg07w89aximdig";
            }).outPath;
            src = fetchzip {
              url    = "https://github.com/echasnovski/mini.test/archive/v0.9.0.zip";
              sha256 = "0sdacbfhbi7z2ah82pdibs5g9cl20bddls6fh6pj4b7rz0qdljhy";
            };

            disabled = luaOlder "5.1";

            meta = {
              homepage = "https://github.com/echasnovski/mini.test";
              description = "Test neovim plugins. Part of the mini.nvim suite.";
              license.fullName = "MIT";
            };
          }) {};
      in {
        devShells.default = pkgs.mkShell {
          name = "lua devShell";
          shellHook = ''
            ln -fs ${pkgs.luarc-to-json luarc} .luarc.json
          '';
          buildInputs = with pkgs; [
            lua-language-server
            stylua
            (lua5_1.withPackages (luaPkgs:
              with luaPkgs; [
                luarocks
                luacheck
                busted
                nlua
                mini-test
              ]))
          ];
        };
      };
    };
}
