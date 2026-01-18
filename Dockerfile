# syntax=docker/dockerfile:1

FROM python:3.12-slim AS builder

# Install uv in the build stage
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Create venv and install pocket-tts from package
WORKDIR /app
ENV UV_COMPILE_BYTECODE=1
ENV UV_LINK_MODE=copy
RUN --mount=type=cache,target=/root/.cache/uv \
    uv venv /app/.venv && \
    uv pip install --python /app/.venv/bin/python pocket-tts

# Runtime stage
FROM python:3.12-slim

WORKDIR /app
ENV PATH="/app/.venv/bin:${PATH}"

# Copy only the virtual environment from builder
COPY --from=builder /app/.venv /app/.venv

# Copy entrypoint script
COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

# Set default command
CMD ["/app/entrypoint.sh"]
