{ config, lib, pkgs, ... }:

{
  options.applications.media = {
    enable = lib.mkEnableOption "media applications";
    
    graphics = {
      gimp = lib.mkEnableOption "GIMP image editor";
    };
    
    audio = {
      audacity = lib.mkEnableOption "Audacity audio editor";
      enableLameSupport = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable LAME MP3 encoding support in audio tools";
      };
    };
    
    video = {
      vlc = lib.mkEnableOption "VLC media player";
    };
  };

  config = lib.mkIf config.applications.media.enable {
    environment.systemPackages = with pkgs; lib.optionals config.applications.media.graphics.gimp [
      gimp
    ] ++ lib.optionals config.applications.media.audio.audacity [
      audacity
      (if config.applications.media.audio.enableLameSupport 
       then sox.override { enableLame = true; }
       else sox)
    ] ++ lib.optionals config.applications.media.video.vlc [
      vlc
    ];
  };
}
