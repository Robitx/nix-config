```
nix-shell -p git neovim
git clone https://github.com/Robitx/nix-config.git
cd nix-config
mkpasswd -m sha-512 > passwords/USERNAME
lsblk
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix --arg device '"/dev/DEVICE"'
lsblk
sudo nixos-install --root /mnt --flake ~/nix-config#default
```
