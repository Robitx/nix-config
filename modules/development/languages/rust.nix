{ config, lib, pkgs, ... }:

{
  options.development.languages.rust = {
    enable = lib.mkEnableOption "Rust development environment";

    channel = lib.mkOption {
      type = lib.types.enum [ "stable" "beta" "nightly" ];
      default = "stable";
      description = "Rust toolchain channel to use";
    };

    components = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "rustc" "cargo" "rustfmt" "clippy" "rust-analyzer" ];
      description = "Rust components to install";
    };

    targets = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Additional compilation targets";
      example = [ "wasm32-unknown-unknown" "x86_64-pc-windows-gnu" ];
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional Rust-related packages";
    };
  };

  config = lib.mkIf config.development.languages.rust.enable {
    environment.systemPackages = with pkgs; [
      # Rust toolchain manager
      rustup
      
      # Additional build dependencies that Rust projects often need
      openssl
      pkg-config
      
    ] ++ config.development.languages.rust.extraPackages;

    environment.variables = {
      # Rust environment
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      
      # Cargo home (user-specific, but good to set system default)
      CARGO_HOME = "/home/tibor/.cargo";
    };

    # Ensure Cargo directories exist for users
    systemd.tmpfiles.rules = [
      "d /home/tibor/.cargo 0755 tibor users -"
      "d /home/tibor/.cargo/bin 0755 tibor users -"
    ];

    # Add cargo bin to PATH for all users
    environment.pathsToLink = [ "/home/tibor/.cargo/bin" ];
  };
}
