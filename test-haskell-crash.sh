#!/usr/bin/env bash

echo "=== Testing Haskell file crash ==="

# Create a minimal Haskell file for testing
TEST_FILE="/tmp/test-minimal.hs"
cat > "$TEST_FILE" << 'EOF'
module Test where

main :: IO ()
main = putStrLn "Hello"
EOF

echo "1. Testing with NO config (should work):"
nvim -u NONE -c "set nocompatible" -c "e $TEST_FILE" -c "qa!" && echo "✓ SUCCESS: No config works" || echo "✗ FAILED: Even with no config"

echo -e "\n2. Testing with MINIMAL config (no plugins):"
nvim --clean -c "e $TEST_FILE" -c "qa!" && echo "✓ SUCCESS: Clean mode works" || echo "✗ FAILED: Clean mode crashes"

echo -e "\n3. Testing with syntax OFF:"
nvim -u NONE -c "syntax off" -c "filetype off" -c "e $TEST_FILE" -c "qa!" && echo "✓ SUCCESS: No syntax works" || echo "✗ FAILED: Even without syntax"

echo -e "\n4. Testing current nixvim config:"
echo "(This will likely crash)"
timeout 5s nix run . -- "$TEST_FILE" -c "qa!" && echo "✓ SUCCESS: Config works" || echo "✗ FAILED: Config crashes (expected)"

echo -e "\n5. Checking Neovim's Haskell runtime files:"
find "$(nix eval --raw nixpkgs#neovim-unwrapped.outPath 2>/dev/null || echo /nix/store/*neovim*)/share/nvim/runtime" -name "*haskell*" -type f 2>/dev/null | head -5

echo -e "\n6. Testing treesitter parser status:"
cat > /tmp/test-treesitter.lua << 'EOF'
-- Check if Haskell parser is installed
vim.cmd [[set runtimepath+=$HOME/.local/share/nvim/site]]
vim.cmd [[set runtimepath+=/nix/store/*/vim-pack-dir/pack/myNeovimPackages/start/*]]

local ok, ts = pcall(require, 'nvim-treesitter.parsers')
if ok then
  local parser_config = ts.get_parser_configs()
  if parser_config.haskell then
    print("Haskell parser config found")
    local installed = ts.has_parser('haskell')
    print("Haskell parser installed: " .. tostring(installed))
    
    if installed then
      -- Try to get parser info
      local lang = require'nvim-treesitter.parsers'.get_buf_lang(0)
      print("Buffer language: " .. tostring(lang))
    end
  else
    print("No Haskell parser config")
  end
else
  print("Treesitter not loaded")
end
EOF

echo -e "\n7. Checking treesitter parser:"
nix run . -- -u NONE -l /tmp/test-treesitter.lua -c "qa!" 2>&1 | grep -E "(parser|haskell|error)"

echo -e "\n=== Diagnosis Summary ==="
echo "If test 1-3 work but 4 fails, it's a nixvim config issue"
echo "If even test 1 fails, it might be a system-level issue"