{ stdenv, wayland, wayland-scanner, pkg-config }:

stdenv.mkDerivation {
  pname = "river-status";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [ pkg-config wayland-scanner ];
  buildInputs = [ wayland ];

  buildPhase = ''
    runHook preBuild
    wayland-scanner client-header "$src/river-status-unstable-v1.xml" river-status-unstable-v1-client-protocol.h
    wayland-scanner private-code "$src/river-status-unstable-v1.xml" river-status-unstable-v1-protocol.c
    $CC -O2 river-status.c river-status-unstable-v1-protocol.c \
      $(pkg-config --cflags --libs wayland-client) \
      -o river-status
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 river-status "$out/bin/river-status"
    runHook postInstall
  '';
}
