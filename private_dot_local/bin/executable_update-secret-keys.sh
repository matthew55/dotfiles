#!/usr/bin/env bash
# Syncs all SSH and GPG keys into KeePassXC so that Chezmoi can decrypt them on new systems automatically.

set -e

# Configuration
DB_PATH="$HOME/.local/share/secrets/Secrets.kdbx"
SSH_PATH="$HOME/.ssh"
GPG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/gnupg"

SSH_ENTRY="SSH/SSH Key Attachments"
GPG_ENTRY="GPG/GPG Key Attachments"

# --- Flag Parsing ---
FORCE_FLAG=""
while getopts "f" opt; do
  case $opt in
    f) FORCE_FLAG="-f" ;;
    *) echo "Usage: $0 [-f]"; exit 1 ;;
  esac
done

# Should be set, but be safe
export GNUPGHOME="$GPG_DATA_HOME"

read -r -s -p "Enter Master Password for $DB_PATH: " PASSWORD
echo ""

# --- SSH Section ---
echo "Processing SSH keys from $SSH_PATH..."
if [ -d "$SSH_PATH" ]; then
    # Using a while loop to handle filenames with spaces safely
    find "$SSH_PATH" -maxdepth 1 -type f ! -name "*.socket" | while read -r file_path; do
        filename=$(basename "$file_path")
        echo "Attaching SSH file: $filename..."
        echo "$PASSWORD" | keepassxc-cli attachment-import -q $FORCE_FLAG "$DB_PATH" "$SSH_ENTRY" "$filename" "$file_path"
    done
else
    echo "SSH directory not found, skipping..."
fi

# --- GPG Section ---
echo "Processing GPG keys..."
PUB_TMP=$(mktemp)
SEC_TMP=$(mktemp)
OWN_TMP=$(mktemp)

gpg --armor --export > "$PUB_TMP"
gpg --armor --export-secret-keys > "$SEC_TMP"
gpg --export-ownertrust > "$OWN_TMP"

upload_gpg() {
    echo "Attaching GPG $1..."
    echo "$PASSWORD" | keepassxc-cli attachment-import -q $FORCE_FLAG "$DB_PATH" "$GPG_ENTRY" "$2" "$3"
}

upload_gpg "Public Keys" "public_keys.asc" "$PUB_TMP"
upload_gpg "Private Keys" "private_keys.asc" "$SEC_TMP"
upload_gpg "Trust Settings" "trust_settings.txt" "$OWN_TMP"

rm -f "$PUB_TMP" "$SEC_TMP" "$OWN_TMP"

unset PASSWORD
echo "Done! All keys have been synced to KeePassXC."
