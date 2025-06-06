{ config, lib, pkgs, ... }:

{
  options.development.languages.rust = {
    enable = lib.mkEnableOption "Rust development environment";

    channel = lib.mkOption {
      type = lib.types.enum [ "stable" "beta" "nightly" ];
      default = "stable";
      description = "Rust toolchain channel to use";
    };

    enableLSP = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include rust-analyzer language server";
    };

    enableCargoTools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include additional cargo tools (audit, outdated, etc.)";
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional Rust-related packages";
    };
  };

  config = lib.mkIf config.development.languages.rust.enable {
    environment.systemPackages = with pkgs; [
      # Core Rust toolchain
      rustc
      cargo
      rustfmt
      clippy
      
      # Build dependencies that most Rust projects need
      openssl
      pkg-config
      
    ] ++ lib.optionals config.development.languages.rust.enableLSP [
      # Language server
      rust-analyzer
      
    ] ++ lib.optionals config.development.languages.rust.enableCargoTools [
      # Additional cargo tools
      cargo-audit
      cargo-outdated
      cargo-edit
      cargo-watch
      
    ] ++ config.development.languages.rust.extraPackages;

    environment.variables = {
      # Rust environment
      RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      RUST_BACKTRACE = lib.mkDefault "1";
      CARGO_HOME = "/home/tibor/.cargo";
    };

    # Ensure Cargo directories exist
    systemd.tmpfiles.rules = [
      "d /home/tibor/.cargo 0755 tibor users -"
      "d /home/tibor/.cargo/bin 0755 tibor users -"
    ];

    # Useful Rust development aliases
    environment.shellAliases = {
      "cr" = "cargo run";
      "ct" = "cargo test";
      "cb" = "cargo build";
      "cc" = "cargo check";
      "cf" = "cargo fmt";
      "ccl" = "cargo clippy";
    };
  };
}
