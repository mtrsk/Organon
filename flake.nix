{
  description = "Nix Dependencies";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        texenv = pkgs.texlive.combine {
          inherit (pkgs.texlive)
          accsupp
          collection-basic
          collection-fontsextra
          collection-fontsrecommended
          collection-langenglish
          collection-langportuguese
          collection-latexextra
          collection-mathscience
          extsizes
          etoolbox
          hyphen-portuguese
          latexmk
          paracol
          pdfx
          ragged2e
          scheme-medium
          ;
        };
        inherit (pkgs)
          dotnet-sdk
          gnumake
          stdenv
          mkShell
          ;
      in
      {
        devShells.default = mkShell {
          buildInputs = [
            gnumake
            dotnet-sdk
            texenv
          ];
        };
      });
}
