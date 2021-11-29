let
  nixpkgs = import (fetchTarball {
    # For compiled binary, run
    # `cachix use jechol`
    url = "https://github.com/jechol/nixpkgs/archive/otp24-no-jit.tar.gz";
    sha256 = "sha256:01n9hn9v7w9kgcd4zipf08bg9kskmpm7sp7f8z3yawk2c0w7q2kl";
  }) { };
  platform = if nixpkgs.stdenv.isDarwin then [
    nixpkgs.darwin.apple_sdk.frameworks.CoreServices
    nixpkgs.darwin.apple_sdk.frameworks.Foundation
  ] else if nixpkgs.stdenv.isLinux then
    [ nixpkgs.inotify-tools ]
  else
    [ ];
in nixpkgs.mkShell {
  buildInputs = with nixpkgs;
    [
      # OTP
      erlang
      elixir
    ] ++ platform;
}
