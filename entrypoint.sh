#!/bin/sh
set -e

# Build command arguments
ARGS="--host ${POCKET_TTS_HOST:-0.0.0.0} --port ${POCKET_TTS_PORT:-8000}"

# Add voice if specified
if [ -n "$POCKET_TTS_VOICE" ]; then
  ARGS="$ARGS --voice $POCKET_TTS_VOICE"
fi

exec /app/.venv/bin/pocket-tts serve $ARGS
