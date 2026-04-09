#!/usr/bin/env bash
set -eu

# ---- config ----
AUTOSSH_BIN="/usr/bin/autossh"
SSH_HOST="utylee@192.168.1.202"
SSH_PORT="8822"

# autossh options
OPTS=(
  -M 0
  -N
  -p "$SSH_PORT"

  -o BindAddress=192.168.100.103   # 🔥 핵심 
  -o ServerAliveInterval=10
  -o ServerAliveCountMax=2
  -o TCPKeepAlive=yes
  -o ExitOnForwardFailure=yes
  -o ConnectTimeout=5
  -o ConnectionAttempts=1

  -R 0.0.0.0:8813:127.0.0.1:8811
)

LOG_DIR="$HOME/logs"
LOG_FILE="$LOG_DIR/autossh-tunnels.log"

mkdir -p "$LOG_DIR"

# autossh env
export AUTOSSH_GATETIME=0
export AUTOSSH_POLL=30
export AUTOSSH_FIRST_POLL=10

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG_FILE"
}

# 네트워크 체크 (WSL용)
wait_network() {
  while true; do
    if ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
      return 0
    fi
    log "network not reachable yet; sleep 3"
    sleep 3
  done
}

health_check() {
  ssh \
    -p "$SSH_PORT" \
    -o BatchMode=yes \
    -o ConnectTimeout=5 \
    -o ConnectionAttempts=1 \
    -o ServerAliveInterval=5 \
    -o ServerAliveCountMax=1 \
    "$SSH_HOST" "true" >/dev/null 2>&1
}

main_loop() {
  while true; do
    wait_network
    log "starting autossh..."

    "$AUTOSSH_BIN" "${OPTS[@]}" "$SSH_HOST" >>"$LOG_FILE" 2>&1 &
    PID=$!
    log "autossh pid=$PID"

    fail=0
    while kill -0 "$PID" 2>/dev/null; do
      sleep 15

      if ! ping -c 1 -W 1 1.1.1.1 >/dev/null 2>&1; then
        log "network lost → kill autossh"
        kill "$PID" 2>/dev/null || true
        wait "$PID" 2>/dev/null || true
        break
      fi

      if health_check; then
        fail=0
      else
        fail=$((fail+1))
        log "health_check failed ($fail/3)"
        if [ "$fail" -ge 3 ]; then
          log "health_check failed 3 times → restart autossh"
          kill "$PID" 2>/dev/null || true
          wait "$PID" 2>/dev/null || true
          break
        fi
      fi
    done

    log "autossh exited; cool down 2s"
    sleep 2
  done
}

main_loop
