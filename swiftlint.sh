export PATH="$PATH:/opt/homebrew/bin"

if which mint; then
    mint run swiftlint
else
    echo "warning: Mint not installed, download from https://github.com/yonaskolb/Mint"
fi
