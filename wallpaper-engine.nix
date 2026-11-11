{ config, lib, pkgs, ... }:

let
  cfg = config.theme.wallpaperEngine;
  wallpaper-engine-kde = pkgs.callPackage ./wallpaper-engine-kde.nix { };
in
{
  options.theme.wallpaperEngine = {
    enable = lib.mkEnableOption "Wallpaper Engine integration for KDE Plasma 6";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      wallpaper-engine-kde
    ];
  };
}