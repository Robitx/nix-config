{ config, lib, pkgs, ... }:

{
  options.applications.productivity = {
    enable = lib.mkEnableOption "productivity applications";
    
    office = {
      libreoffice = lib.mkEnableOption "LibreOffice suite";
      spellcheck = lib.mkEnableOption "spell checking support";
      languageTools = lib.mkEnableOption "grammar and style checking";
    };
    
    notes = {
      obsidian = lib.mkEnableOption "Obsidian note-taking app";
    };
    
    downloads = {
      qbittorrent = lib.mkEnableOption "qBittorrent client";
    };
    
    cad = {
      prusaSlicer = lib.mkEnableOption "PrusaSlicer for 3D printing";
      superSlicer = lib.mkEnableOption "SuperSlicer for 3D printing";
      openscad = lib.mkEnableOption "OpenSCAD for 3D modeling";
    };
    
    archives = lib.mkEnableOption "archive and compression tools";
  };

  config = lib.mkIf config.applications.productivity.enable {
    environment.systemPackages = with pkgs; lib.optionals config.applications.productivity.office.libreoffice [
      libreoffice-fresh
    ] ++ lib.optionals config.applications.productivity.office.spellcheck [
      hunspell
      hunspellDicts.en_US
    ] ++ lib.optionals config.applications.productivity.office.languageTools [
      languagetool
    ] ++ lib.optionals config.applications.productivity.notes.obsidian [
      obsidian
    ] ++ lib.optionals config.applications.productivity.downloads.qbittorrent [
      qbittorrent
    ] ++ lib.optionals config.applications.productivity.cad.prusaSlicer [
      prusa-slicer
    ] ++ lib.optionals config.applications.productivity.cad.openscad [
        openscad
    ] ++ lib.optionals config.applications.productivity.cad.superSlicer [
        super-slicer
    ] ++ lib.optionals config.applications.productivity.archives [
      p7zip
      cabextract
      unrar
      unzip
      zip
      xz
      zstd
    ];
  };
}
