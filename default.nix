{ rustPlatform
, fetchurl
, fetchFromGitHub
, defaultCrateOverrides
, callPackage
, lib

, cmake
, pkgconfig
, fontconfig
, cargo
, rustc
, python
, llvmPackages_latest
, vulkan-tools

, expat
, openssl
, freetype
, harfbuzz
, icu
, libjpeg_turbo
, libpng
, zlib
, SDL2
, vulkan-loader
, cacert
}:
let
  skia = callPackage ./skia.nix {};
in rustPlatform.buildRustPackage rec {
  pname = "neovide";
  version = "0.6.0";
  src = fetchFromGitHub {
    # owner = "Kethku";
    owner = "teto";
    repo = "neovide";
    rev = "71646517a00bf484ef0a563c785c581d58593658"; 
    sha256 = "sha256-sSljltbA/WcSz2EfhT2O8KYiQOcyj8tO77X08+uhOGQ=";
    # lib.fakeSha256;

  };
  # src = builtins.filterSource
  #   (path: type:
  #     type == "directory"
  #     || lib.strings.hasSuffix ".rs" path
  #     || lib.strings.hasSuffix ".h" path
  #     || lib.strings.hasSuffix ".cpp" path
  #     || lib.strings.hasSuffix ".toml" path
  #     || lib.strings.hasSuffix ".lock" path
  #     || lib.strings.hasSuffix ".otf" path
  #     || lib.strings.hasSuffix ".desktop" path
  #     || lib.strings.hasSuffix ".ico" path
  #   )
  #   ./.;
  # cargoSha256 = "0qkililxcwjhsvk354ly0bz1gxfqa65ka66f3zri85n3gr9fr397";
  cargoSha256 = "sha256-9uSAXPbauRY1XJguUrzhY7HWu5ycBDz2IDAUXttWGLs=";

  SSL_CERT_FILE = "${cacert.out}/etc/ssl/certs/ca-bundle.crt";
  nativeBuildInputs = [
    cacert
    cmake
    pkgconfig
    cargo
    rustc
    python
    vulkan-tools
  ] ++ (with llvmPackages_latest; [
    clang
    llvm
  ]);
  buildInputs = [
    fontconfig
    skia
    expat
    openssl
    freetype
    SDL2
    vulkan-loader
  ];


  shellHook = ''
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${vulkan-loader}/lib"
  '';
}

