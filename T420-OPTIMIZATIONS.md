# T420 ThinkPad Optimizations for uCore

This config is tuned specifically for ThinkPad T420 systems with i5-2520M (Sandy Bridge).

## What's Optimized

### 🔋 Power Management
- **TLP**: Advanced power management for laptops
- **CPU frequency scaling**: Uses `schedutil` governor optimized for Sandy Bridge
- **Battery care**: Proper charge thresholds and power saving

### 🖱️ TrackPoint
- **Sensitivity**: Set to 200 (more responsive)
- **Speed**: Set to 120 (faster cursor movement)
- **Middle-button scrolling**: Automatically configured

### 🎮 Intel GPU (HD 3000)
- **Framebuffer compression**: Enabled for better performance
- **PSR disabled**: Sandy Bridge PSR is buggy, disabled for stability
- **Modesetting**: Enabled for proper resolution handling

### 💾 Memory Management
- **zram**: Compressed swap in RAM (great for 8GB systems)
- **Swappiness**: Lowered to 10 (prefer RAM over swap)
- **Cache pressure**: Optimized for limited RAM

### 📡 Network
- **TCP FastOpen**: Enabled for faster connections
- **Network buffers**: Increased for better throughput

### 📦 Additional Packages
- `tlp` + `tlp-rdw` - Power management
- `powertop` - Power usage analysis
- `zram-generator-defaults` - Compressed RAM swap

## Hardware Specs Supported

- **CPU**: i5-2520M (Sandy Bridge, x86-64-v2)
- **RAM**: 12GB (optimized, zram gives you ~15GB effective)
- **GPU**: Intel HD 3000 (dGPU disabled for better battery life)
- **WiFi**: Intel Centrino Advanced-N 6205
- **Display**: 1920x1080 IPS panel

## Installation

Use the T420-specific butane config:

```bash
./build-custom-iso.sh examples/ucore-autorebase-t420.butane testing
```

This will create an ISO optimized for your T420 fleet!

## Boot Sequence (4 reboots for T420)

1. **Boot 1**: Installs FCOS + WiFi drivers → reboot
2. **Boot 2**: Installs TLP, zram, power tools → reboot
3. **Boot 3**: Rebases to your uCore (unsigned) → reboot
4. **Boot 4**: Rebases to signed image → **Ready!**

## Post-Install Tweaks

### Check TLP Status
```bash
sudo tlp-stat
```

### Monitor Power Usage
```bash
sudo powertop
```

### Check CPU Governor
```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

### Test TrackPoint
Middle-button should scroll by default. If not:
```bash
xinput list  # find TrackPoint device
xinput list-props <device-id>
```

## Battery Tips for Old Batteries

Your T420 batteries are old but working - here's how to keep them that way:

```bash
# Check battery health
upower -i /org/freedesktop/UPower/devices/battery_BAT0

# TLP will automatically:
# - Limit charge to 80% when plugged in long-term
# - Use conservative charge thresholds
# - Reduce wear on cells
```

## Why These Optimizations Matter

- **Sandy Bridge**: Needs specific CPU governor tuning
- **12GB RAM**: zram gives you ~25% more effective memory (~15GB total)
- **Old batteries**: TLP extends their remaining life
- **1080p display**: Proper i915 settings prevent tearing
- **TrackPoint**: The best pointing device deserves proper config

## Benchmark Expectations

On a T420 with 12GB RAM and SSD:
- **Boot time**: ~15 seconds to login
- **Container startup**: Near instant with podman
- **Memory usage**: ~500MB idle (with zram giving you more headroom)
- **Battery life**: 3-4 hours on original batteries with TLP

Your $80 ThinkPads are about to become the best damn immutable container hosts ever made! 🚀
