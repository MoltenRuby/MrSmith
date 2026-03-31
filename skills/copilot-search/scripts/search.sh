#!/bin/bash
# search.sh — GitHub Copilot semantic search wrapper
# Usage: search.sh <query>
QUERY=$1

# -p  prompt text
# -s  silent (no spinners/metadata)
# --allow-all-tools  permit file search without per-tool prompts
copilot -p "Semantic search: $QUERY. Return only the relevant file paths and a brief explanation." \
  -s --allow-all-tools
