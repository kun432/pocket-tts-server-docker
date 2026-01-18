# syntax=docker/dockerfile:1

FROM ghcr.io/astral-sh/uv:debian AS builder

# Clone the official pocket-tts repository
WORKDIR /app
ENV UV_CACHE_DIR=/root/.cache/uv
ENV UV_PYTHON_CACHE_DIR=/root/.cache/uv/python
RUN git clone --depth 1 https://github.com/kyutai-labs/pocket-tts.git .

# Install dependencies and build
RUN uv sync --frozen --no-dev

# Runtime stage
FROM ghcr.io/astral-sh/uv:debian

WORKDIR /app
ENV UV_CACHE_DIR=/root/.cache/uv
ENV UV_PYTHON_CACHE_DIR=/root/.cache/uv/python

# Copy built environment from builder
COPY --from=builder /app /app
COPY --from=builder /root/.cache/uv /root/.cache/uv

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set default command
CMD ["/app/entrypoint.sh"]
