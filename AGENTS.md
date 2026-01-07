# NixOS Configuration - Agent Guide

This is a NixOS flake-based configuration using impermanence (ephemeral root filesystem).

## Key Files

| File | Purpose |
|------|---------|
| `flake.nix` | Flake inputs and machine definitions (tibor480, tiborzen) |
| `configuration.nix` | Main config - enables modules via options |
| `home.nix` | Home Manager config - user dotfiles and persistence |
| `disko.nix` | Disk partitioning (ZFS with impermanence) |

## Module Structure

```
modules/
  default.nix           # Imports all module categories
  system/               # Boot, base system, persistence
  desktop/              # Hyprland, Sway, audio, bluetooth, fonts, utilities
  development/          # Dev tools and languages
    base.nix            # Core dev tools (always with development.enable)
    containers.nix      # Docker/Podman
    languages/          # go, rust, python, javascript, lua, c
    tools/              # vscode, git, kubernetes, opencode, antigravity-fhs
  applications/         # Browsers, communication, media, productivity, utilities
  services/             # System services
  users/                # User definitions
  hardware/             # Machine-specific hardware configs
  overlays/             # Package overlays
```

## Adding a New Development Tool

1. **Create module** at `modules/development/tools/<toolname>.nix`:

```nix
{ config, lib, pkgs, ... }:

{
  options.development.tools.<toolname> = {
    enable = lib.mkEnableOption "Tool description";
    
    # Optional: feature flags
    enableFeature = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include optional feature";
    };
    
    # Optional: extra packages
    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Additional packages";
    };
  };

  config = lib.mkIf config.development.tools.<toolname>.enable {
    environment.systemPackages = with pkgs; [
      main-package
    ] ++ lib.optionals config.development.tools.<toolname>.enableFeature [
      optional-package
    ] ++ config.development.tools.<toolname>.extraPackages;

    # Optional: aliases, env vars, etc.
    environment.shellAliases = { };
    environment.variables = { };
  };
}
```

2. **Register** in `modules/development/tools/default.nix`:
```nix
imports = [
  # ...existing imports...
  ./<toolname>.nix
];
```

3. **Enable** in `configuration.nix`:
```nix
development.tools.<toolname>.enable = true;
```

4. **Persist config** in `home.nix` under `home.persistence."/persist/home/tibor".directories`:
```nix
".config/<toolname>"
".local/share/<toolname>"
```

## Adding a New Language

Same pattern as tools, but in `modules/development/languages/`.

## Impermanence

This config uses NixOS impermanence - root filesystem is ephemeral and wiped on boot.

**System persistence**: Defined in `modules/system/persistence.nix`
**User persistence**: Defined in `home.nix` under `home.persistence."/persist/home/tibor"`

When adding new tools, check if they create config/data directories that need persisting:
- `~/.config/<app>` - Configuration
- `~/.local/share/<app>` - Data/state
- `~/.cache/<app>` - Cache (usually fine to lose)

## Common Nix Patterns

```nix
lib.mkEnableOption "description"     # Boolean enable option
lib.mkOption { type, default, desc } # Custom option
lib.mkIf condition { ... }           # Conditional config
lib.optionals bool [ items ]         # Conditional list items
lib.mkMerge [ attrsets ]             # Merge multiple attrsets
with pkgs;                           # Shorthand for pkgs.X
```

## Applying Changes

```bash
update        # nixos-rebuild boot
update-test   # nixos-rebuild test (no boot entry)
update-full   # nix flake update + rebuild
update-safe   # update only nixpkgs + home-manager
```

## Machines

- `tibor480` - Laptop
- `tiborzen` - Desktop (Zen)

Both share `configuration.nix` and `home.nix`, with hardware-specific configs in `modules/hardware/`.
