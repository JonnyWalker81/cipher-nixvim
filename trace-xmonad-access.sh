#!/usr/bin/env bash

# Script to trace what happens when accessing xmonad.hs file
echo "=== Tracing xmonad.hs file access ==="

# Check file properties
echo -e "\n1. File properties:"
ls -la ~/nixos-config/users/xmonad/xmonad.hs
file ~/nixos-config/users/xmonad/xmonad.hs
stat ~/nixos-config/users/xmonad/xmonad.hs

# Check if file is corrupted
echo -e "\n2. File integrity:"
head -5 ~/nixos-config/users/xmonad/xmonad.hs | cat -v
echo "..."
tail -5 ~/nixos-config/users/xmonad/xmonad.hs | cat -v

# Check for special characters
echo -e "\n3. Special characters check:"
grep -P '[^\x00-\x7F]' ~/nixos-config/users/xmonad/xmonad.hs && echo "Found non-ASCII characters" || echo "No non-ASCII characters"

# Check git status of the file
echo -e "\n4. Git status:"
cd ~/nixos-config
git status users/xmonad/xmonad.hs
git ls-files --error-unmatch users/xmonad/xmonad.hs 2>&1

# Check for symlinks
echo -e "\n5. Symlink check:"
readlink -f ~/nixos-config/users/xmonad/xmonad.hs

# Memory map when reading file
echo -e "\n6. Testing file read with strace:"
timeout 2s strace -e openat,read,mmap cat ~/nixos-config/users/xmonad/xmonad.hs > /dev/null 2>&1 | grep -E "(xmonad|FAULT|ERROR)" | head -10

# Check system limits
echo -e "\n7. System limits:"
ulimit -a | grep -E "(data|stack|memory)"

# Test minimal vim operations
echo -e "\n8. Testing vim operations:"
echo "vim -u NONE -c 'e ~/nixos-config/users/xmonad/xmonad.hs' -c 'qa'" 
timeout 5s vim -u NONE -c "e ~/nixos-config/users/xmonad/xmonad.hs" -c "qa" 2>&1 && echo "SUCCESS: vim can open file" || echo "FAILED: vim cannot open file"

echo -e "\n=== End of diagnostics ==="
echo "If any of the above tests fail or show errors, that might be the cause of the crash"