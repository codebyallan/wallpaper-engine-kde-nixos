let
  src = builtins.fetchGit {
    url = "https://github.com/codebyallan/wallpaper-engine-kde-nixos";
  };
in
import "${src}/wallpaper-engine.nix"