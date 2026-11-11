let
  src = builtins.fetchGit {
    url = "https://github.com/codebyallan/wallpaper-engine-kde-nixos";
    rev = "b0e13bf9427c275a946368563425bbf9c1558d94";
  };
in
import "${src}/wallpaper-engine.nix"