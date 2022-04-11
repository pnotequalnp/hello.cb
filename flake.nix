{
  inputs = {
    nixpkgs.url = "nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    carbon.url = "github:pnotequalnp/carbon/flake";
  };

  outputs = { self, nixpkgs, flake-utils, carbon }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "x86_64-darwin" ]
      (system:
        let
          pkgs = import nixpkgs { inherit system; };
          hello-carbon = pkgs.writeShellScriptBin "hello" ''
            ${carbon.packages.${system}.carbon}/bin/carbon ${./src/Main.cb}
          '';
        in
        rec {
          packages = rec {
            hello = hello-carbon;
            default = hello;
          };

          apps = rec {
            hello = flake-utils.lib.mkApp { drv = packages.hello; };
            default = hello;
          };
        });
}
