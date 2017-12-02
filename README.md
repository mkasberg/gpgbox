# GPGBox

Securely store a folder in Dropbox using GPG.

GPGBox is really just a simple shell script that makes it easy to encrypt an
entire folder into a single encrypted file (for example, to put in Dropbox). It
also makes it easy to decrypt that file and get the folder back.

## Installation

First, make sure you have GPG installed.

 * Linux: Should already be installed. Otherwise, `sudo apt-get install gpg`.
 * macOS: `brew install gpg`.

GPGBox is really just a Bash script. Install it by adding it to your path, or by
copying or symlinking it to a location in your path. For your convenience, a
Makefile is provided to help with this (or just do it yourself, if you prefer).

    $ make install

or

    $ ln -s `realpath gpgbox.sh` ~/bin/gpgbox

or

    $ cp gpgbox.sh /usr/local/bin/gpgbox

## Usage

If you want to store sensitive information (tax documents, bank account info,
etc.) in Dropbox (or a similar service), it's a good idea to encrypt it first.
GPGBox is a simple shell script to make this easier.

 1. Run `gpgbox --init`. This creates `~/Desktop/GPGBox`. Put any files you want
    to securely encrypt in this folder. You can add folders, documents, and any
    other kind of file you want.
 2. Run `gpgbox -e`. `~/Desktop/GPGBox` is encrypted with a passphrase of your
    choice and saved to `~/Dropbox/GPGBox.tar.gz.gpg`. The folder on your
    desktop is removed (you don't want the unencrypted files hanging around, and
    you don't want them to get out of sync with Dropbox).
 3. When you want to read, add, or delete files, run `gpgbox -d`. Unencrypted
    documents become available at `~/Desktop/GPGBox`.
 4. When you're done, either delete the folder `~/Desktop/GPGBox` or run `gpgbox
    -e` to save your changes.

## Notes

 * GPG does the heavy lifting, reducing the risk of a bug causing a security
   flaw.
 * GPG is widely available, and easy to get on Linux and macOS.
 * We never want the unencrypted folder to be a subdirectory of `~/Dropbox`
   (because then it would be synced by Dropbox, and remain in the Dropbox trash
   even after it is deleted from the local machine).

