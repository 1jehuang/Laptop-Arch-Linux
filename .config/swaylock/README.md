# Swaylock Configuration

## Files

- `config` - Configuration for swaylock-fprintd with fingerprint support
- `pam-swaylock` - PAM configuration for fingerprint authentication

## Installation

```bash
# Install swaylock-fprintd for automatic fingerprint scanning
yay -S swaylock-fprintd-git

# Copy PAM config
sudo cp pam-swaylock /etc/pam.d/swaylock

# Copy config file
cp config ~/.config/swaylock/config
```

## Usage

```bash
# Lock with automatic fingerprint scanning
swaylock -p
```

## Features

- **Automatic fingerprint scanning** - No need to press Enter first
- **Password fallback** - Works if fingerprint fails
- **Beautiful styling** - Custom colors and fonts
- **Modern design** - Clean, minimal interface