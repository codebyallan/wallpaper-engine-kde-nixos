{ lib
, stdenv
, cmake
, ninja
, pkg-config
, vulkan-headers
, vulkan-loader
, lz4
, freetype
, mpv
, libpulseaudio
, gst_all_1
, kdePackages
}:

let
  src = builtins.fetchGit {
    url = "https://github.com/CaptSilver/wallpaper-engine-kde-plugin";
    rev = "8173e09c0175894c0ad655cca022095d7bcd03dc";
    submodules = true;
  };
in
stdenv.mkDerivation {
  pname = "wallpaper-engine-kde";
  version = "unstable";
  inherit src;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
    lz4
    freetype
    mpv
    libpulseaudio
    gst_all_1.gst-libav
    kdePackages.plasma-workspace
    kdePackages.libplasma
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kpackage
    kdePackages.knotifications
    kdePackages.kcrash
    kdePackages.kglobalaccel
    kdePackages.ki18n
    kdePackages.kxmlgui
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtwebchannel
    kdePackages.qtwebengine
  ];

  meta = {
    description = "Wallpaper Engine integration for KDE Plasma 6";
    homepage = "https://github.com/CaptSilver/wallpaper-engine-kde-plugin";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
  };
}