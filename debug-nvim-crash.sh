#!/usr/bin/env bash

# Script to debug nvim crash when searching for files starting with "x"
# This captures output and enables debugging features

echo "Starting Neovim with debugging enabled..."
echo "When ready, try searching for files starting with 'x' to reproduce the crash"
echo "----------------------------------------"

# Enable core dumps
ulimit -c unlimited

# Set debug environment variables
export NVIM_LOG_FILE="/tmp/nvim-debug.log"
export VIM_LOG_LEVEL=10

# Run neovim with error output captured
echo "Running: nix run . -- -V3 2>&1 | tee /tmp/nvim-crash-output.txt"
nix run . -- -V3 2>&1 | tee /tmp/nvim-crash-output.txt

# Check exit code
EXIT_CODE=$?
echo "----------------------------------------"
echo "Neovim exited with code: $EXIT_CODE"

# Check for crash output
if [ -f /tmp/nvim-crash-output.txt ]; then
    echo "Crash output saved to: /tmp/nvim-crash-output.txt"
    echo "Last 20 lines:"
    tail -20 /tmp/nvim-crash-output.txt
fi

# Check for debug log
if [ -f /tmp/nvim-debug.log ]; then
    echo "----------------------------------------"
    echo "Debug log saved to: /tmp/nvim-debug.log"
    echo "Last 20 lines:"
    tail -20 /tmp/nvim-debug.log
fi

# Check for core dump
CORE_FILE=$(find . -name "core.*" -type f -mmin -5 2>/dev/null | head -1)
if [ -n "$CORE_FILE" ]; then
    echo "----------------------------------------"
    echo "Core dump found: $CORE_FILE"
    echo "You can analyze it with: gdb $(which nvim) $CORE_FILE"
fi