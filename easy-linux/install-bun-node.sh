# We're installing BUN instead of Node
# and aliasing `node` to `bun` to avoid heavy node&npm packages and making it faster.

sudo apt install curl unzip
curl -fsSL https://bun.com/install | bash





# 1. Clean up any existing aliases and functions in your current session
unalias node npm npx ts-node 2>/dev/null
unset -f node npm ts-node 2>/dev/null

# 2. Inject the complete Bun-replacement suite into your bash profile
cat << 'EOF' >> ~/.bashrc

# ==========================================
# ULTIMATE NODE -> BUN REPLACEMENT SUITE
# ==========================================

# 1. Replace node with Bun (Handles files and strings)
node() {
    if [ "$1" = "-e" ]; then
        bun -e "$2"
    else
        bun run "$@"
    fi
}

# 2. Replace ts-node with Bun's native TypeScript execution
ts-node() {
    if [ "$1" = "-e" ] || [ "$1" = "-p" ]; then
        bun "$1" "$2"
    else
        bun run "$@"
    fi
}

# 3. Replace npm commands with Bun equivalents
npm() {
    if [ "$1" = "i" ] || [ "$1" = "install" ]; then
        shift
        bun add "$@"
    elif [ "$1" = "uni" ] || [ "$1" = "uninstall" ] || [ "$1" = "remove" ]; then
        shift
        bun remove "$@"
    elif [ "$1" = "exec" ]; then
        shift
        bunx "$@"
    else
        bun "$@"
    fi
}

# 4. Replace npx with bunx
alias npx="bunx"

EOF

# 3. Reload your bash profile to activate everything instantly
source ~/.bashrc

# 4. Fix system shebangs (e.g., #!/usr/bin/env node) to point to Bun
# (Enter your system password if prompted)
sudo ln -sf ~/.bun/bin/bun /usr/local/bin/node

# 1. Clear current memory of the function
unset -f node

# 2. Inject the bulletproof suite into your bash profile
cat << 'EOF' >> ~/.bashrc

# Bulletproof Node -> Bun Wrapper
node() {
    if [ -z "$1" ]; then
        # If no arguments are passed, open Bun's interactive REPL
        bun repl
    elif [ "$1" = "-e" ]; then
        bun -e "$2"
    else
        bun run "$@"
    fi
}
EOF

# 3. Reload your profile
source ~/.bashrc


# 1. Remove the problematic symlink we made earlier
sudo rm /usr/local/bin/node

# 2. Create a brand new, smart script file at that location
sudo touch /usr/local/bin/node

# 3. Make the file writable so we can add the logic
sudo chmod +x /usr/local/bin/node

# 4. Inject the smart routing logic directly into the system-wide node file
cat << 'EOF' | sudo tee /usr/local/bin/node > /dev/null
#!/bin/bash
if [ -z "$1" ]; then
    # If a tool calls 'node' with no arguments, trick it by returning a valid Node v22 string
    # or drop into bun's repl if a human is running it in a terminal.
    if [ -t 0 ]; then
        exec ~/.bun/bin/bun repl
    else
        echo "v22.12.0"
    fi
elif [ "$1" = "-v" ] || [ "$1" = "--version" ]; then
    # Force output a modern Node version string to satisfy the build tool's version checks
    echo "v22.12.0"
elif [ "$1" = "-e" ]; then
    exec ~/.bun/bin/bun -e "$2"
else
    exec ~/.bun/bin/bun run "$@"
fi
EOF
