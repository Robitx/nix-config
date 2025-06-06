{ config, lib, pkgs, ... }:

{
  options.applications.utilities = {
    enable = lib.mkEnableOption "system utility applications";
    
    system = {
      diskUsage = lib.mkEnableOption "disk usage analyzer (baobab)";
      partitioning = lib.mkEnableOption "partition editor (gparted)";
      fileComparison = lib.mkEnableOption "file comparison tool (meld)";
      calendar = lib.mkEnableOption "command line calendar (ccal)";
      systemInfo = lib.mkEnableOption "hardware information tools";
    };
    
    network = {
      basic = lib.mkEnableOption "basic network utilities";
      vpn = lib.mkEnableOption "VPN tools";
      security = lib.mkEnableOption "network security tools";
    };
    
    packageManager = lib.mkEnableOption "Nix helper tools";
  };

  config = lib.mkIf config.applications.utilities.enable {
    environment.systemPackages = with pkgs; lib.optionals config.applications.utilities.system.diskUsage [
      baobab
    ] ++ lib.optionals config.applications.utilities.system.partitioning [
      gparted
    ] ++ lib.optionals config.applications.utilities.system.fileComparison [
      meld
    ] ++ lib.optionals config.applications.utilities.system.calendar [
      ccal
    ] ++ lib.optionals config.applications.utilities.system.systemInfo [
      lshw
    ] ++ lib.optionals config.applications.utilities.network.basic [
      inetutils
      dnsutils
      dig
      whois
      ipcalc
      geoip
      swaks
    ] ++ lib.optionals config.applications.utilities.network.vpn [
      openvpn
      openssl
    ] ++ lib.optionals config.applications.utilities.packageManager [
      nurl
      nh
    ];

    # Enable NetworkManager if network utilities are requested
    networking.networkmanager.enable = lib.mkIf config.applications.utilities.network.basic true;
  };
}
