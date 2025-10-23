# Your Custom uCore Setup

Your fork is now configured to build and use YOUR custom uCore images!

## 🎯 What Changed

- `examples/ucore-autorebase.butane` now points to `ghcr.io/jstamagal/ucore:testing`
- Created `build-custom-iso.sh` script for easy ISO generation

## 🚀 Workflow Status

Check your builds at: https://github.com/jstamagal/ucore/actions

Your workflows are building:
- **stable** stream (FC42): `ghcr.io/jstamagal/ucore:stable` (+ nvidia variant)
- **testing** stream (FC43): `ghcr.io/jstamagal/ucore:testing` (+ nvidia variant)

Each build creates 3 image variants:
- `ucore-minimal` - Lightweight container host
- `ucore` - Full featured with storage tools
- `ucore-hci` - HCI with libvirt/KVM

## 📀 Create Your ISO (after builds finish)

```bash
# For FC43 (testing) - recommended since you're on FC43
./build-custom-iso.sh examples/ucore-autorebase.butane testing

# For FC42 (stable)
./build-custom-iso.sh examples/ucore-autorebase.butane stable
```

This creates `ucore-testing-installer.iso` ready to write to USB.

## 💾 Write to USB

```bash
# Find your USB device
lsblk

# Write ISO (replace /dev/sdX with your USB device!)
sudo dd if=ucore-testing-installer.iso of=/dev/sdX bs=4M status=progress && sync
```

## 🔐 Your Cosign Setup

✅ Your `cosign.pub` is already in place
✅ Images will be signed with your private key (from GitHub secrets)
✅ After boot 2, system will verify signatures using your public key

## 🔄 Boot Sequence

1. **Boot 1**: Installs FCOS, adds WiFi drivers → reboot
2. **Boot 2**: WiFi connects, rebases to `ghcr.io/jstamagal/ucore:testing` (unsigned) → reboot
3. **Boot 3**: Rebases to signed image → **Ready to use!**

## 🎮 First Login

```bash
# Login as: tj (password from your butane config)

# Check what you're running
rpm-ostree status

# Enable services you want
sudo systemctl enable --now cockpit.socket  # Web UI at https://your-ip:9090
sudo systemctl enable --now tailscaled      # If using Tailscale

# Start using containers!
podman run -d --name nginx -p 8080:80 nginx
```

## 🛠️ Customizing Your Image

Want to add packages or make changes? Edit:
- `ucore/Containerfile` - Main build instructions
- `ucore/install-ucore*.sh` - Package lists and setup
- Push changes, workflows auto-rebuild!

## ❓ Troubleshooting

**Build failed?** Check: https://github.com/jstamagal/ucore/actions
**No WiFi on boot 1?** Expected - it installs on first boot
**Stuck at boot?** Press Ctrl+Alt+F2 to see system logs

## 📚 Next Steps

Once running, check out:
- README.md - Full uCore documentation
- Fedora CoreOS docs: https://docs.fedoraproject.org/en-US/fedora-coreos/

Welcome to your custom immutable distro! 🎉
