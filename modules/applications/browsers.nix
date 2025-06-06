{ config, lib, pkgs, ... }:

{
  options.applications.browsers = {
    enable = lib.mkEnableOption "web browsers";
    
    chrome = lib.mkEnableOption "Google Chrome";
    vivaldi = lib.mkEnableOption "Vivaldi browser";
    firefox = lib.mkEnableOption "Firefox browser";
    
    defaultBrowser = lib.mkOption {
      type = lib.types.nullOr (lib.types.enum [ "chrome" "vivaldi" "firefox" ]);
      default = null;
      description = "Default browser to set";
    };
  };

  config = lib.mkIf config.applications.browsers.enable {
    environment.systemPackages = with pkgs; lib.optionals config.applications.browsers.chrome [
      google-chrome
    ] ++ lib.optionals config.applications.browsers.vivaldi [
      vivaldi
    ] ++ lib.optionals config.applications.browsers.firefox [
      firefox
    ];

    # Set default browser if specified
    environment.sessionVariables = lib.mkIf (config.applications.browsers.defaultBrowser != null) {
      BROWSER = 
        if config.applications.browsers.defaultBrowser == "chrome" then "google-chrome-stable"
        else if config.applications.browsers.defaultBrowser == "vivaldi" then "vivaldi"
        else if config.applications.browsers.defaultBrowser == "firefox" then "firefox"
        else "";
    };
  };
}
