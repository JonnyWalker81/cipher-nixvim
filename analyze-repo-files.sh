#!/usr/bin/env bash

# Script to analyze files in a repository that might cause the malloc crash
# Usage: ./analyze-repo-files.sh /path/to/problematic/repo

REPO_PATH="${1:-.}"

echo "Analyzing repository: $REPO_PATH"
echo "========================================="

# Check for files starting with 'x' or 'X'
echo -e "\n1. Files starting with 'x' or 'X':"
find "$REPO_PATH" -name "[xX]*" -type f 2>/dev/null | head -20

echo -e "\n2. Count of files starting with 'x':"
find "$REPO_PATH" -name "[xX]*" -type f 2>/dev/null | wc -l

# Check for unusual characters in filenames starting with x
echo -e "\n3. Files with special characters starting with 'x':"
find "$REPO_PATH" -name "[xX]*" -type f 2>/dev/null | grep -E '[^a-zA-Z0-9._/-]' | head -10

# Check for very long filenames starting with x
echo -e "\n4. Files with long names (>100 chars) starting with 'x':"
find "$REPO_PATH" -name "[xX]*" -type f 2>/dev/null | while read -r file; do
    basename_len=${#file}
    if [ $basename_len -gt 100 ]; then
        echo "$file (length: $basename_len)"
    fi
done | head -10

# Check for symbolic links starting with x
echo -e "\n5. Symbolic links starting with 'x':"
find "$REPO_PATH" -name "[xX]*" -type l 2>/dev/null | head -10

# Check for files with null bytes or special encodings
echo -e "\n6. Files with potential encoding issues starting with 'x':"
find "$REPO_PATH" -name "[xX]*" -type f 2>/dev/null | while read -r file; do
    if file "$file" | grep -E "(data|binary|UTF-16|UTF-32)" >/dev/null; then
        echo "$file: $(file "$file")"
    fi
done | head -10

# Check total file count and directory structure
echo -e "\n7. Repository statistics:"
echo "Total files: $(find "$REPO_PATH" -type f 2>/dev/null | wc -l)"
echo "Total directories: $(find "$REPO_PATH" -type d 2>/dev/null | wc -l)"
echo "Files in .git: $(find "$REPO_PATH/.git" -type f 2>/dev/null | wc -l)"

# Check for large files starting with x
echo -e "\n8. Large files (>10MB) starting with 'x':"
find "$REPO_PATH" -name "[xX]*" -type f -size +10M 2>/dev/null -exec ls -lh {} \; | head -10

# Check for hidden files starting with x
echo -e "\n9. Hidden files starting with '.x':"
find "$REPO_PATH" -name ".x*" -type f 2>/dev/null | head -10

# Check git status if it's a git repo
if [ -d "$REPO_PATH/.git" ]; then
    echo -e "\n10. Git status:"
    cd "$REPO_PATH" && git status --porcelain | grep "^[?MAD].*[xX]" | head -10
fi

echo -e "\n========================================="
echo "Analysis complete. Look for any unusual patterns above."