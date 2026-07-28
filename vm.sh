#!/usr/bin/env bash
#
# vm.sh — start/stop/restart the Windows lab VMs by argument.
#
# Usage:
#   ./vm.sh <start|stop|restart|status> [vm-name ...]
#
# If no vm-name is given, the action applies to ALL lab VMs (see DEFAULT_VMS).
#
# Examples:
#   ./vm.sh start                 # start every lab VM
#   ./vm.sh stop member01         # gracefully shut down just member01
#   ./vm.sh restart AD-DS-vm      # power-cycle the DC (reconnects NIC after network changes)
#   ./vm.sh status                # show the state of every lab VM

set -euo pipefail

LIBVIRT_URI="qemu:///system"
DEFAULT_VMS=(AD-DS-vm member01)
# Seconds to wait for a graceful shutdown before forcing power-off.
SHUTDOWN_TIMEOUT="${SHUTDOWN_TIMEOUT:-10}"

usage() {
  sed -n '3,15p' "$0" | sed 's/^# \{0,1\}//'
}

# Use plain virsh if the current user can reach the system daemon (libvirt group);
# otherwise fall back to sudo.
VIRSH="virsh -c $LIBVIRT_URI"
if ! $VIRSH list >/dev/null 2>&1; then
  VIRSH="sudo virsh -c $LIBVIRT_URI"
fi

vm_exists() { $VIRSH dominfo "$1" >/dev/null 2>&1; }
vm_state()  { $VIRSH domstate "$1" 2>/dev/null || echo "unknown"; }

do_start() {
  local vm=$1
  if [[ "$(vm_state "$vm")" == "running" ]]; then
    echo "[$vm] already running"
    return 0
  fi
  echo "[$vm] starting..."
  $VIRSH start "$vm"
}

do_stop() {
  local vm=$1
  local state
  state=$(vm_state "$vm")
  if [[ "$state" != "running" ]]; then
    echo "[$vm] not running (state: $state)"
    return 0
  fi
  echo "[$vm] shutting down gracefully (up to ${SHUTDOWN_TIMEOUT}s)..."
  $VIRSH shutdown "$vm" || true
  local i
  for ((i = 0; i < SHUTDOWN_TIMEOUT; i++)); do
    [[ "$(vm_state "$vm")" != "running" ]] && { echo "[$vm] stopped"; return 0; }
    sleep 1
  done
  echo "[$vm] still running after ${SHUTDOWN_TIMEOUT}s — forcing power off"
  $VIRSH destroy "$vm"
}

do_restart() {
  local vm=$1
  do_stop "$vm"
  do_start "$vm"
}

do_status() {
  local vm=$1
  printf '%-14s %s\n' "$vm" "$(vm_state "$vm")"
}

main() {
  [[ $# -lt 1 ]] && { usage; exit 1; }

  local action=$1
  shift
  local vms=("$@")
  [[ ${#vms[@]} -eq 0 ]] && vms=("${DEFAULT_VMS[@]}")

  local fn
  case "$action" in
    start)          fn=do_start ;;
    stop)           fn=do_stop ;;
    restart)        fn=do_restart ;;
    status)         fn=do_status ;;
    -h|--help|help) usage; exit 0 ;;
    *) echo "Unknown action: '$action'" >&2; usage; exit 1 ;;
  esac

  local vm rc=0
  for vm in "${vms[@]}"; do
    if ! vm_exists "$vm"; then
      echo "[$vm] does not exist — skipping" >&2
      rc=1
      continue
    fi
    "$fn" "$vm"
  done
  return $rc
}

main "$@"
