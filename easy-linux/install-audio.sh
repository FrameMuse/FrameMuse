sudo apt update
sudo apt install pipewire-audio wireplumber pipewire-pulse pipewire-alsa pipewire-jack libspa-0.2-bluetooth

systemctl --user --now disable pulseaudio.service pulseaudio.socket
systemctl --user mask pulseaudio.service

systemctl --user --now enable pipewire.service wireplumber.service pipewire-pulse.service

sudo usermod -aG audio $USER

# ---

mkdir -p ~/.config/pipewire/pipewire.conf.d/
cat << 'EOF' > ~/.config/pipewire/pipewire.conf.d/custom-audio.conf
context.properties = {
    # Match the sample rates your hardware and music files actually use
    default.clock.allowed-rates = [ 44100 48000 88200 96000 192000 ]
    
    # Optional: Lower default quantum sizes can reduce physical audio latency
    default.clock.quantum       = 1024
    default.clock.min-quantum   = 32
    default.clock.max-quantum   = 2048
}
EOF

cat << 'EOF' > /etc/modprobe.d/audio-powersave.conf
options snd_hda_intel power_save=0
options snd_usb_audio ignore_ctl_error=1
EOF

mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
cat << 'EOF' > ~/.config/wireplumber/wireplumber.conf.d/10-bluez.conf
monitor.bluez.rules = [
  {
    matches = [
      {
        device.name = "~bluez_card.*"
      }
    ]
    actions = {
      update-props = {
        # Forces High Quality ("hq") for LDAC instead of auto scaling
        bluez5.a2dp.ldac.quality = "hq"
      }
    }
  }
]
EOF

systemctl --user restart pipewire pipewire-pulse wireplumber && systemctl --user status pipewire wireplumber --no-pager