# Easy Linux

A cumulative guide how to get the best Linux Debian/Ubuntu/Mint GNOME experience for an average user.

*This guide this cover how to dedicate disk space to linux or how to get to installed linux,*
*this guide assumes, you have JUST installed linux or at the stage of installation/setup.*

## Faster Browser

```bash
sudo apt install profile-sync-daemon
```

Edit `# BROWSERS=()` to something like `BROWSERS=(google-chrome firefox)`

```bash
nano ~/.config/psd/psd.conf
```

## Mount `/tmp` to RAM

```bash
sudo nano /etc/fstab
```
