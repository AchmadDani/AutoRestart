#!/usr/bin/env bash
# auto-power.sh
# Usage:
#   sudo ./auto-power.sh <shutdown|reboot> <now|+Nm|"YYYY-MM-DD HH:MM"> [--test]
#
# Examples:
#   sudo ./auto-power.sh shutdown now
#   sudo ./auto-power.sh reboot "+15m"
#   sudo ./auto-power.sh shutdown "2025-12-12 02:30"
#   ./auto-power.sh shutdown now --test   # <-- safe, tidak akan reboot

set -e

ACTION="$1"
TIMEARG="$2"
TESTFLAG="$3"

if [[ -z "$ACTION" || -z "$TIMEARG" ]]; then
  echo "Usage: $0 <shutdown|reboot> <now|+Nm|\"YYYY-MM-DD HH:MM\"> [--test]"
  exit 1
fi

if [[ "$ACTION" != "shutdown" && "$ACTION" != "reboot" ]]; then
  echo "Action harus 'shutdown' atau 'reboot'"
  exit 1
fi

# Tentukan perintah shutdown sesuai argumen
if [[ "$TIMEARG" == "now" ]]; then
  if [[ "$ACTION" == "shutdown" ]]; then
    CMD=(shutdown -h now)
  else
    CMD=(shutdown -r now)
  fi
elif [[ "$TIMEARG" =~ ^\+[0-9]+[mM]$ ]]; then
  minutes="${TIMEARG:1:${#TIMEARG}-2}"
  if [[ "$ACTION" == "shutdown" ]]; then
    CMD=(shutdown -h +"$minutes")
  else
    CMD=(shutdown -r +"$minutes")
  fi
else
  # gunakan waktu absolut (bisa "HH:MM" atau "YYYY-MM-DD HH:MM")
  if [[ "$ACTION" == "shutdown" ]]; then
    CMD=(shutdown -h "$TIMEARG")
  else
    CMD=(shutdown -r "$TIMEARG")
  fi
fi

# Mode test -> hanya tampilkan perintah, tidak dieksekusi
if [[ "$TESTFLAG" == "--test" ]]; then
  echo "[TEST MODE] Perintah yang akan dijalankan:"
  printf '%q ' "${CMD[@]}"
  echo
  echo "Batalkan jadwal: sudo shutdown -c"
  exit 0
fi

# Eksekusi (butuh sudo / root)
echo "Menjalankan:"
printf '%q ' "${CMD[@]}"
echo
sudo "${CMD[@]}"
