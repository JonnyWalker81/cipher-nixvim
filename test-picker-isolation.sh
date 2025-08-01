#!/usr/bin/env bash

# Test script to isolate the picker crash issue
# This tests different search methods in the problematic repo

REPO_PATH="${1:-.}"

echo "Testing different search methods in: $REPO_PATH"
echo "========================================="

cd "$REPO_PATH" || exit 1

# Test 1: Basic find command
echo -e "\n1. Testing basic find command for files starting with 'x':"
if timeout 5s find . -name "x*" -type f 2>/dev/null | head -5; then
    echo "✓ Basic find works"
else
    echo "✗ Basic find failed or timed out"
fi

# Test 2: fd command (if available)
if command -v fd &> /dev/null; then
    echo -e "\n2. Testing fd command for files starting with 'x':"
    if timeout 5s fd "^x" --type f 2>/dev/null | head -5; then
        echo "✓ fd works"
    else
        echo "✗ fd failed or timed out"
    fi
fi

# Test 3: ripgrep files
if command -v rg &> /dev/null; then
    echo -e "\n3. Testing ripgrep --files for 'x' pattern:"
    if timeout 5s rg --files | grep "^[^/]*x" 2>/dev/null | head -5; then
        echo "✓ ripgrep --files works"
    else
        echo "✗ ripgrep --files failed or timed out"
    fi
fi

# Test 4: Git ls-files (if git repo)
if [ -d .git ]; then
    echo -e "\n4. Testing git ls-files for 'x' pattern:"
    if timeout 5s git ls-files | grep "^x" 2>/dev/null | head -5; then
        echo "✓ git ls-files works"
    else
        echo "✗ git ls-files failed or timed out"
    fi
fi

# Test 5: Check for problematic file patterns
echo -e "\n5. Checking for potentially problematic patterns:"
echo "Files with spaces starting with 'x':"
find . -name "x*" -type f 2>/dev/null | grep " " | head -3

echo -e "\nFiles with unicode starting with 'x':"
find . -name "x*" -type f 2>/dev/null | grep -P "[^\x00-\x7F]" | head -3

echo -e "\nVery deep paths starting with 'x':"
find . -name "x*" -type f 2>/dev/null | awk -F/ 'NF>10' | head -3

echo -e "\n========================================="
echo "If any of these tests fail or show unusual files, that might be the cause."