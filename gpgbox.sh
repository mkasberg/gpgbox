#!/usr/bin/env bash

# gpgbox
#
# Uses GPG to encrypt a folder with a passphrase.
# For example, use this to securely store a folder into Dropbox.

# Configurable file locations
ENCRYPTED=~/Dropbox/GPGBox.tar.gz.gpg
DECRYPTED=~/Desktop/GPGBox

# Stop on error. And even if in a pipe.
set -e
set -o pipefail

# RTFM. I like to keep this near the top.
function print_help {
    cat<<EOD
Usage: gpgbox COMMAND

COMMANDS:
  --init         Initialize a new GPGBox (on the Desktop).
  -e, --encrypt  Encrypt the folder at $DECRYPTED
                 to $ENCRYPTED.
                 Then erase $DECRYPTED.
  -d, --decrypt  Decrypt the file at $ENCRYPTED
                 to $DECRYPTED.
  -h, --help     Print this help message.

Ex:
$ gpgbox --init
$ echo "foo" > ~/Desktop/GPGBox/foo.txt
$ gpgbox -e
...
$ gpgbox -d
EOD
}

function do_encrypt {
    if [[ ! -d "$DECRYPTED" ]]; then
        echo "ERROR: Not a directory $DECRYPTED" >&2
        exit 1
    fi

    echo "Encrypting $DECRYPTED to $ENCRYPTED..."

    # Create a zipped tar of $DECRYPTED with relative paths,
    # pipe it to gpg in symmetric mode and output to $ENCRYPTED.
    tar -cz -f- -C "$DECRYPTED" . | gpg -c -o "$ENCRYPTED"

    # Don't leave the decrypted stuff hanging around.
    rm -rf $DECRYPTED
}

function do_decrypt {
    if [[ ! -e "$ENCRYPTED" ]]; then
        echo "ERROR: File does not exist $ENCRYPTED" >&2
        exit 1
    fi

    echo "Decrypting $ENCRYPTED to $DECRYPTED..."

    # We want this to error if the dir exists.
    mkdir "$DECRYPTED"

    # Decrypt $ENCRYPTED to stdout, pipe it to
    # tar, extract gzip into the $DECRYPTED dir.
    gpg -o- "$ENCRYPTED" | tar -xz -C "$DECRYPTED"
}

function do_init {
    mkdir -p "$DECRYPTED"
}

# Begin main script.
# Parse command line args.
OPTS=`getopt -o deh --long decrypt,encrypt,help,init -n 'gpgbox' -- "$@"`
if [ $? != 0 ] ; then echo "Failed parsing options." >&2 ; exit 1 ; fi

DECRYPT=false
ENCRYPT=false
HELP=false
INIT=false

while true; do
  case "$1" in
    -d | --decrypt ) DECRYPT=true; shift;;
    -e | --encrypt ) ENCRYPT=true; shift ;;
    -h | --help )    HELP=true; shift ;;
    --init ) INIT=true; shift;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done

if [[ "$HELP" = "true" ]]; then
    print_help
    exit 0
fi

if [[ "$INIT" = "true" ]]; then
    do_init
    exit 0
fi

# Now, do it!
if [[ "$DECRYPT" = "true" && "$ENCRYPT" = "true" ]] || [[ "$DECRYPT" != "true" && "$ENCRYPT" != "true" ]]; then
    echo -e "Please specify either encrypt or decrypt option.\n"
    print_help
    exit 1
elif [[ "$ENCRYPT" = "true" ]]; then
    do_encrypt
elif [[ "$DECRYPT" = "true" ]]; then
    do_decrypt
fi

