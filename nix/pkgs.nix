let
  # (1)
  # FIXME pin to specific version
  haskellNix = import (builtins.fetchTarball https://github.com/input-output-hk/haskell.nix/archive/master.tar.gz) {}; #/archive/21a6d6090a64ef5956c9625bcf00a15045d65042.tar.gz) {};

  # (2)
  nixpkgsSrc = haskellNix.sources.nixpkgs-2003;
  nixpkgsArgs = haskellNix.nixpkgsArgs;

  # (3)
  native = import nixpkgsSrc nixpkgsArgs;

  crossRpi = import nixpkgsSrc (nixpkgsArgs // {
    crossSystem = native.lib.systems.examples.raspberryPi;
  });

  crossArmv7l = import nixpkgsSrc (nixpkgsArgs // {
    crossSystem = native.lib.systems.examples.raspberryPi;
  });

  crossMusl = import nixpkgsSrc (nixpkgsArgs // {
    crossSystem = native.lib.systems.examples.musl64;
  });
in {
  # (4)

  inherit haskellNix;

  inherit nixpkgsSrc nixpkgsArgs;

  inherit native crossRpi crossArmv7l crossMusl;
}
