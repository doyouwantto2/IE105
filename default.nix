{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    langchain
    langgraph
    langsmith
    langchain-ollama
    pytest
    numpy
    ollama           
    pandas
    matplotlib
  ]);

in
pkgs.mkShell {
  name = "IE105";

  buildInputs = with pkgs; [
    pythonEnv
    ollama           

    curl
    git
    ripgrep
  ];

  shellHook = ''
  '';
}
