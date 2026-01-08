#!/usr/bin/env bash

apps=(
  "/Applications/Firefox.app"
  "/Applications/Discord.app"
)
broken_apps=()

task="$1"

function kill_app() {
  local name=$1
  local attempt=10
  local pid

  echo "Killing $name"
  pid=$(pgrep "$name")
  while [[ -n "$pid" ]] && [[ $attempt -gt 0 ]]; do
    echo "PID: $pid"
    kill "$pid"
    sleep 5
    pid=$(pgrep "$name")
    ((attempt-=1))
  done
}

function close_app() {
  local name=$1

  osascript -e "quit app \"$name\""
}

function force_close_app() {
  local name=$1

  osascript -e "quit app \"$name\"" || true > /dev/null 2>&1
}

function open_app() {
  local name=$1

  open "$name"
}

function close_apps() {
  for app in "${apps[@]}"; do
    close_app "$app"
  done;

  for app in "${broken_apps[@]}"; do
    force_close_app "$app"
  done;
}

function open_apps() {
  for app in "${apps[@]}"; do
    open_app "$app"
  done;

  for app in "${broken_apps[@]}"; do
    open_app "$app"
  done;
}

if [ "$task" = "close" ]; then
  close_apps
  exit 0
elif [ "$task" = "open" ]; then
  open_apps
  exit 0
else
  echo "Unknown task"
  exit 1
fi
