{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

pkgs.mkShell {
  name = "IE105";

  packages = with pkgs; [
    python312
    python312Packages.virtualenv

    ollama
    git
    ripgrep
  ];

  shellHook = ''
    if [ ! -d .venv ]; then
      virtualenv --no-setuptools --no-wheel .venv
    fi

    source .venv/bin/activate

    if [ -f requirements.txt ]; then
      STAMP=.venv/.requirements.stamp

      if [ ! -f "$STAMP" ] || [ requirements.txt -nt "$STAMP" ]; then
        python -m pip install -r requirements.txt
        touch "$STAMP"
      fi
    fi
  '';
}
