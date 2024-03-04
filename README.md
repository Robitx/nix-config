## Install 
```
nix-shell -p git neovim tree
git clone https://github.com/Robitx/nix-config.git
cd nix-config
mkpasswd -m sha-512 > passwords/USERNAME
lsblk
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix --arg device '"/dev/DEVICE"'
lsblk
sudo systemd-machine-id-setup --root /mnt --print
sudo cp -r ~/nix-config /mnt/persist/nix-config
sudo nixos-install --impure --no-root-passwd --root /mnt --flake /mnt/persist/nix-config/#MACHINE
```

# Optionals
```
sudo nixos-generate-config --no-filesystems --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/persist/nix-config/
sudo nixos-enter --root /mnt
```
