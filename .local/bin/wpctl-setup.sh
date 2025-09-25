#!/bin/sh
set -e
# Prefer built-in speakers as default sink if present
if pactl list short sinks | grep -q "Speaker__sink"; then
  SINK_NAME=$(pactl list short sinks | awk '/Speaker__sink/{print $2; exit}')
  pactl set-default-sink "$SINK_NAME" || true
fi
# Unmute and set reasonable volumes
wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 || true
wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.90 || true
wpctl set-mute @DEFAULT_AUDIO_SOURCE@ 0 || true
wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 1.00 || true
