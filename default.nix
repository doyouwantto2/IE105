{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  nativeDeps = with pkgs; [
    stdenv.cc.cc.lib    
    zlib
    openssl
    libffi
    readline
    sqlite
    bzip2
    xz
    libxml2
    libxslt
    curl
    freetype            
    libpng              
    gcc                 
    pkg-config
  ];
in
pkgs.mkShell {
  name = "ofmis";

  packages = [
    pkgs.python312
    pkgs.python312Packages.virtualenv
    pkgs.ollama
    pkgs.git
    pkgs.ripgrep
  ] ++ nativeDeps;

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath nativeDeps;
  PKG_CONFIG_PATH = pkgs.lib.makeSearchPathOutput "dev" "lib/pkgconfig" nativeDeps;

  shellHook = ''
    if [ ! -d .venv ]; then
      virtualenv --no-setuptools --no-wheel .venv
    fi

    source .venv/bin/activate

    if [ -f requirements.txt ]; then
      STAMP=.venv/.requirements.stamp

      if [ ! -f "$STAMP" ] || [ requirements.txt -nt "$STAMP" ]; then
        python -m pip install --upgrade pip setuptools wheel
        python -m pip install -r requirements.txt
        touch "$STAMP"
      fi
    fi
  '';
}
