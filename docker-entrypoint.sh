#!/bin/bash
set -e

### Generate name for this client
# Get active interface
IFACE=$(ip route | grep default | awk '{print $5}' | head -n 1)

# Check if IFACE is empty
if [ -z "$IFACE" ]; then
    echo "No active network interface found."
fi

# Check if interface directory exists
if [ ! -e "/sys/class/net/$IFACE/address" ]; then
    echo "Interface $IFACE does not exist or has no MAC address."
fi

# Read MAC address and remove ':'
MAC=$(cat /sys/class/net/$IFACE/address | tr -d ':')

if [ -z "$MAC" ]; then
    echo "Could not read MAC address."
fi

# Generate CLIENT_NAME from it
TEMP_CLIENT_NAME="snapcast-${MAC}"


### Handlers
# Handle parameters
EXTRA_ARGS=""

if [ "$ENABLE_DEBUG" = "1" ]; then
  EXTRA_ARGS="$EXTRA_ARGS --debug"
fi

if [ "$START_SNAPCLIENT" = "true" ]; then
  CLIENT_NAME=${CLIENT_NAME:-$TEMP_CLIENT_NAME}
  if [ -n "${CLIENT_NAME}" ]; then
    EXTRA_ARGS="$EXTRA_ARGS --hostID $CLIENT_NAME"
  fi

  AUDIO_OUTPUT_DEVICE=${AUDIO_OUTPUT_DEVICE:-"pulse"}
  if [ -n "${AUDIO_OUTPUT_DEVICE}" ]; then
    EXTRA_ARGS="$EXTRA_ARGS --soundcard $AUDIO_OUTPUT_DEVICE"
  fi

  SNAPCAST_REMOTE_HOST=${SNAPCAST_REMOTE_HOST:-"tcp://musicassistant.network.local"}
  if [ -n "${SNAPCAST_REMOTE_HOST}" ]; then
    EXTRA_ARGS="$EXTRA_ARGS $SNAPCAST_REMOTE_HOST"
  fi

  ### Wait for PulseAudio
  # Wait for PulseAudio to be available before starting the application
  CP_MAX_RETRIES=30
  CP_RETRY_DELAY=1
  ### while maybe besser?
  echo "Checking port $PORT..."
  for i in $(seq 1 $CP_MAX_RETRIES); do
    # Check if PulseAudio is running
    if pactl info >/dev/null 2>&1; then
      echo "✅ PulseAudio is running"
      break
    fi

    if [ $i -eq $CP_MAX_RETRIES ]; then
        echo "❌ PulseAudio did not start after $CP_MAX_RETRIES seconds"
        exit 2
    fi

    echo "⏳ PulseAudio not running yet, retrying in $CP_RETRY_DELAY s..."
    sleep $CP_RETRY_DELAY
  done
fi

### Start application
if [ "$START_SNAPCLIENT" = "true" ]; then
  echo "starting application in client mode"
  exec /usr/bin/snapclient "$@" $EXTRA_ARGS
elif [ "$START_SNAPSERVER" = "true" ]; then
  echo "starting application in server mode"
  exec /usr/bin/snapserver "$@" $EXTRA_ARGS
else
  echo "Please configure if i should run as server or client"
fi
