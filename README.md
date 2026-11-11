# Wallpaper Engine for KDE Plasma 6 on NixOS

NixOS module that packages the [Wallpaper Engine KDE plugin](https://github.com/CaptSilver/wallpaper-engine-kde-plugin) (CaptSilver fork, Plasma 6 / Qt 6) so it can be enabled declaratively.

The plugin is not in nixpkgs, so the source is fetched with `builtins.fetchGit` at a pinned commit and built with CMake. Scene wallpapers are drawn by the bundled `wallpaper-scene-renderer` submodule, which is fetched recursively.

You still need a Wallpaper Engine license on Steam. This package only provides the KDE plugin and does not include any wallpapers.

Everything is handled by Nix. Nothing is written to `/usr`, and `sudo` is only needed to switch the system configuration.

## What gets installed

| Component | Package | Purpose |
|---|---|---|
| Wallpaper Engine plugin | `wallpaper-engine-kde` (derivation in this repository) | Wallpaper type "Wallpaper Engine" in Plasma settings, video and scene renderer |

## Layout

```
wallpaper-engine-kde-nixos/
├── README.md                       this file
├── wallpaper-engine-theme.nix      bridge file: copy it to /etc/nixos
├── wallpaper-engine.nix            NixOS module: theme.wallpaperEngine.enable option
└── wallpaper-engine-kde.nix        derivation: fetches the source and builds the plugin
```

## Requirements

- NixOS 26.05 with Plasma 6.
- Configuration in `/etc/nixos` using a flake (`nixos-rebuild switch --flake .#cosmos`). Without a flake, use `nixos-rebuild switch` instead.
- GitHub access during the build (the source is fetched with `builtins.fetchGit`).
- Wallpaper Engine bought on Steam, and downloaded at least once so the Workshop folder exists.

## Usage

### 1. Copy the bridge file to `/etc/nixos`

```bash
git clone https://github.com/codebyallan/wallpaper-engine-kde-nixos
sudo cp wallpaper-engine-kde-nixos/wallpaper-engine-theme.nix /etc/nixos/
```

The bridge file loads `wallpaper-engine.nix` from this repository at a pinned commit.

### 2. Configuration

In `/etc/nixos/configuration.nix`:

```nix
imports = [
  ./hardware-configuration.nix
  # ...
  ./wallpaper-engine-theme.nix
];

theme.wallpaperEngine.enable = true;
```

### 3. Apply

```bash
cd /etc/nixos
git add wallpaper-engine-theme.nix   # flakes only see files tracked by git
sudo nixos-rebuild switch --flake .#cosmos
systemctl --user restart plasma-plasmashell
```

### 4. Configure the wallpaper

1. Right-click the desktop and choose **Configure Desktop and Wallpaper**.
2. Set the wallpaper type to **Wallpaper Engine**.
3. Point the library path to your Steam library root. For a native Steam install that is usually:
   ```
   ~/.local/share/Steam
   ```
   The Workshop content is then under `steamapps/workshop/content/431960`.
4. Pick a video wallpaper first. Scene wallpapers are heavier.

## Verify

```bash
ls /run/current-system/sw/share/plasma/wallpapers
```

## Finding the Steam library path

```bash
find ~ -maxdepth 8 -type d -name 431960 2>/dev/null
```

Use the library root that contains `steamapps/workshop/content/431960`.

## Updating the plugin

1. Check the latest upstream commit:
   ```bash
   git ls-remote https://github.com/CaptSilver/wallpaper-engine-kde-plugin HEAD
   ```
2. Change `rev` in `wallpaper-engine-kde.nix`, commit, and push to your repository.
3. Change `rev` in `/etc/nixos/wallpaper-engine-theme.nix` to the new commit of this repository.
4. Run the `switch` command again.

## Troubleshooting

- **Build fails with `attribute missing`:** a dependency name differs in your nixpkgs. Check it with `nix search nixpkgs <name>` and update `wallpaper-engine-kde.nix`.
- **Plugin does not appear in the wallpaper list:** check that the package is in `/run/current-system/sw/share/plasma/wallpapers`, then restart `plasma-plasmashell`.
- **Plasma freezes after applying a wallpaper:** remove the `WallpaperFilePath` line in `~/.config/plasma-org.kde.plasma.desktop-appletsrc` and restart Plasma. This is the recovery step documented by the plugin.
- **Wallpapers do not load:** confirm that the library path points to the root that contains `steamapps`, not to the Workshop folder itself.
- **Scene wallpapers are slow on an older GPU:** use a video wallpaper, or lower the render settings in the plugin.

## Notes

- Wallpaper choices are stored in `~/.config`, which Nix does not manage.
- The plugin is GPL-2.0, same as upstream.