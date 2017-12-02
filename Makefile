# Makefile for gpgbox

# Edit if you want a custom install location.
PREFIX=$(HOME)
BIN=$(PREFIX)/bin

.PHONY: help install uninstall
help:
	@echo "Usage:"
	@echo "  make install    Install to $(BIN)."
	@echo "  make uninstall  Uninstall from $(BIN)."
	@echo "  make help       Print this help message."

install:
	ln -s `realpath gpgbox.sh` $(BIN)/gpgbox

uninstall:
	unlink $(BIN)/gpgbox
