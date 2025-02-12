{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem =
        { self', pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          packages.effectful-microlens = pkgs.haskellPackages.developPackage {
            root = ./.;
          };

          devShells.default = pkgs.haskellPackages.shellFor {
            packages = hpkgs: [
              self'.packages.effectful-microlens
            ];
            nativeBuildInputs = with pkgs; [
              nixfmt-rfc-style
              cabal-install
            ];
          };
        };
    };
}
