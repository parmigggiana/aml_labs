{
  description = "Jupyter development environment";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";

  outputs = { self, nixpkgs }:
    let
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forEachSupportedSystem = f:
        nixpkgs.lib.genAttrs supportedSystems
          (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      devShells = forEachSupportedSystem ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs;
            [ python311 ]
            ++ (with pkgs.python311Packages; [ pip icecream virtualenv black isort ipykernel jupyterlab ]);
          shellHook = ''
            test ! -d .venv && virtualenv --system-site-packages .venv
            source .venv/bin/activate
            echo
            echo "Activated environment"
          '';
        };
      });
    };
}
