# Pocket TTS Server Docker

Docker image for [Kyutai Labs](https://github.com/kyutai-labs/pocket-tts)'s pocket-tts - a lightweight text-to-speech application that runs efficiently on CPUs.

## Quick Start

### Using Docker Compose (Recommended)

```bash
# Local build (for development)
docker compose -f docker-compose.dev.yml up -d --build

# Use pre-built image (for production)
docker compose -f docker-compose.yml up -d
```

Then open http://localhost:8000 in your browser.

### Using Docker directly

```bash
docker run -d -p 8000:8000 ghcr.io/kun432/pocket-tts-server:v0.0.1
```

## Configuration

| Environment Variable | Default | Description |
|---------------------|---------|-------------|
| `POCKET_TTS_HOST` | `0.0.0.0` | Host address to bind to |
| `POCKET_TTS_PORT` | `8000` | Port to listen on |
| `POCKET_TTS_VOICE` | - | Voice to use (see below) |
| `HF_TOKEN` | - | Hugging Face token (required only for voice cloning) |

### .env Example

Create `.env` from `.env.example` and set your token if you use voice cloning.

Example:
```
HF_TOKEN=your_token_here
```

### Custom Port Example

```yaml
# docker-compose.yml
environment:
  - POCKET_TTS_PORT=8080
ports:
  - "8080:8080"
```

Or with Docker:

```bash
docker run -d -p 8080:8080 -e POCKET_TTS_PORT=8080 ghcr.io/kun432/pocket-tts-server:v0.0.1
```

## Voice Selection

You can specify the voice using the `POCKET_TTS_VOICE` environment variable.

> **⚠️ Important:** If you use the built-in voices or Kyutai's TTS voices HuggingFace, each voice may have its own license terms. Please review the original [Kyutai Labs repository](https://github.com/kyutai-labs/pocket-tts) before using voices in production.

### Built-in Voices

```yaml
environment:
  - POCKET_TTS_VOICE=marius
```

Available built-in voices: `alba`, `marius`, `javert`, `jean`, `fantine`, `cosette`, `eponine`, `azelma`

### HuggingFace URL

```yaml
environment:
  - POCKET_TTS_VOICE=hf://kyutai/tts-voices/alba-mackenna/casual.wav
```

### Local Voice File

1. Create a `voices` directory and place your WAV file:
```bash
mkdir voices
cp /path/to/custom.wav voices/custom.wav
```

2. Update docker-compose.yml:
```yaml
environment:
  - POCKET_TTS_VOICE=/voices/custom.wav
volumes:
  - ./voices:/voices:ro
```

Or with Docker:
```bash
docker run -d \
  -p 8000:8000 \
  -e POCKET_TTS_VOICE=/voices/custom.wav \
  -v $(pwd)/voices:/voices:ro \
  ghcr.io/kun432/pocket-tts-server:v0.0.1
```

## Volumes

| Volume | Description |
|--------|-------------|
| `/root/.cache/huggingface` | Cache for downloaded models (~500MB) |
| `/root/.cache/pocket_tts` | Cache for voice state data (speeds up repeated voice usage) |

Both volumes are recommended to persist for faster restarts.

## Images

Multi-platform images available for:
- `linux/amd64`
- `linux/arm64`

**Pull the image:**

```bash
docker pull ghcr.io/kun432/pocket-tts-server:v0.0.1
```

## About

This Docker image automatically builds [pocket-tts](https://github.com/kyutai-labs/pocket-tts) from source. The original project is licensed under the MIT License by Kyutai Labs.

**Source:** https://github.com/kyutai-labs/pocket-tts
**License:** MIT
