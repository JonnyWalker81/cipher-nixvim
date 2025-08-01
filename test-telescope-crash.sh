#!/usr/bin/env bash

# Test if telescope crashes with specific patterns
echo "Testing telescope crash with 'xmon' pattern"
echo "==========================================="

# Test 1: Create a test directory with similar files
TEST_DIR="/tmp/telescope-crash-test"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Create test files
echo "test content" > xmonad.hs
echo "test content" > xmonitor.txt
echo "test content" > xmono.log
echo "test content" > test.txt
echo "test content" > example.hs

echo "Created test files in $TEST_DIR:"
ls -la

# Test 2: Try to reproduce with minimal vim config
cat > /tmp/minimal-telescope.vim << 'EOF'
set rtp+=/nix/store/*/vim-pack-dir/pack/myNeovimPackages/start/telescope.nvim
set rtp+=/nix/store/*/vim-pack-dir/pack/myNeovimPackages/start/plenary.nvim

lua << LUA
require('telescope').setup{}

-- Try to search
vim.defer_fn(function()
  print("Testing telescope with pattern 'xmon'...")
  local ok, err = pcall(function()
    require('telescope.builtin').find_files({
      search_string = 'xmon',
      cwd = '/tmp/telescope-crash-test'
    })
  end)
  if not ok then
    print("Error: " .. tostring(err))
  else
    print("Search completed without crash")
  end
end, 100)
LUA
EOF

echo -e "\nTesting with minimal config..."
nvim -u /tmp/minimal-telescope.vim -c "qa" 2>&1 | tee /tmp/telescope-test-output.txt

# Test 3: Check if it's related to the specific directory
echo -e "\nTesting in nixos-config directory..."
cd ~/nixos-config
timeout 5s nvim -c "Telescope find_files search=xmon" -c "qa" 2>&1 | tee /tmp/telescope-nixos-test.txt || echo "Command timed out or crashed"

echo -e "\n==========================================="
echo "Check these files for errors:"
echo "- /tmp/telescope-test-output.txt"
echo "- /tmp/telescope-nixos-test.txt"