#!/bin/zsh

set -e

cd "$(dirname "$0")"
export PATH="$HOME/.local/bin:$PATH"

open "http://127.0.0.1:4173/"
npm run start
