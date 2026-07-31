{ config, lib, pkgs, ... }:

{
  options.services.scanner = {
    enable = lib.mkEnableOption "SANE scanner support";

    gui = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install simple-scan (GNOME Document Scanner) frontend";
    };

    xsane = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Install XSane frontend (advanced options, GIMP plugin)";
    };

    extraBackends = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Additional (non-default) SANE backends, e.g. pkgs.sane-airscan";
    };

    tools = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install CLI tools (scanimage, OCR, PDF assembly)";
    };
  };

  config = lib.mkIf config.services.scanner.enable {
    # Canon CanoScan LiDE 400 is handled by the `genesys` backend, which ships
    # with sane-backends. No firmware or proprietary blob is required.
    hardware.sane = {
      enable = true;
      extraBackends = config.services.scanner.extraBackends;
    };

    users.users."tibor".extraGroups = [ "scanner" "lp" ];

    environment.systemPackages =
      lib.optionals config.services.scanner.gui [ pkgs.simple-scan ]
      ++ lib.optionals config.services.scanner.xsane [
        (pkgs.xsane.override { gimpSupport = true; })
      ]
      ++ lib.optionals config.services.scanner.tools [
        pkgs.sane-backends # scanimage, scanadf
        pkgs.imagemagick # convert scans
        pkgs.img2pdf # lossless image -> PDF
        pkgs.ocrmypdf # searchable PDFs
      ];
  };
}
