```bash
mkpasswd -m sha-512 > passwords/username
```

Drive formating:
```
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko ./disko.nix --arg device '"/dev/DEVICE"'
```
