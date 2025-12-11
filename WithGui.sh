#!/usr/bin/env bash
# auto-power-menu.sh
# Interaktif menu untuk shutdown/reboot sekarang atau terjadwal.

set -euo pipefail

show_menu() {
  clear
  cat <<'EOF'
========================================
    AUTO POWER (Menu Interaktif)
========================================
1) Shutdown sekarang
2) Reboot sekarang
3) Shutdown terjadwal (masukkan jam)
4) Reboot terjadwal   (masukkan jam)
5) Keluar
========================================
EOF
}

confirm_and_run() {
  local cmd_display="$1"
  local cmd_exec="$2"

  echo
  echo "Perintah yang akan dijalankan:"
  echo "  $cmd_display"
  echo
  read -rp "Konfirmasi jalankan sekarang? (y/N): " ans
  case "$ans" in
    [yY]|[yY][eE][sS])
      echo "Menjalankan..."
      # jalankan dengan sudo (akan meminta password jika perlu)
      sudo bash -c "$cmd_exec"
      ;;
    *)
      echo "Dibatalkan oleh user."
      ;;
  esac
  read -rp $'\nTekan Enter untuk kembali ke menu...' _
}

parse_time_and_build_cmd() {
  # $1 = action ("shutdown" atau "reboot")
  # $2 = time input (like now, +5m, HH:MM, YYYY-MM-DD HH:MM)
  local action="$1"
  local timearg="$2"
  local cmd_display cmd_exec

  if [[ "$timearg" == "now" ]]; then
    if [[ "$action" == "shutdown" ]]; then
      cmd_display="shutdown -h now"
      cmd_exec="shutdown -h now"
    else
      cmd_display="shutdown -r now"
      cmd_exec="shutdown -r now"
    fi
  elif [[ "$timearg" =~ ^\+[0-9]+[mM]$ ]]; then
    # +Nm (minutes)
    if [[ "$action" == "shutdown" ]]; then
      cmd_display="shutdown -h $timearg"
      cmd_exec="shutdown -h $timearg"
    else
      cmd_display="shutdown -r $timearg"
      cmd_exec="shutdown -r $timearg"
    fi
  else
    # assume "HH:MM" or "YYYY-MM-DD HH:MM" — shutdown accepts these formats
    if [[ "$action" == "shutdown" ]]; then
      cmd_display="shutdown -h \"$timearg\""
      cmd_exec="shutdown -h \"$timearg\""
    else
      cmd_display="shutdown -r \"$timearg\""
      cmd_exec="shutdown -r \"$timearg\""
    fi
  fi

  # return via global vars
  CMD_DISPLAY="$cmd_display"
  CMD_EXEC="$cmd_exec"
}

read_schedule_time() {
  local prompt_msg="$1"
  local user_input
  local now
  now=$(date +"%Y-%m-%d %H:%M:%S")
  echo
  echo "Waktu saat ini: $now"
  echo "Masukkan waktu jadwal. Format yang diterima:"
  echo "  - +Nm  (contoh: +5m untuk 5 menit dari sekarang)"
  echo "  - HH:MM  (contoh: 23:30 untuk hari ini pada jam 23:30)"
  echo "  - YYYY-MM-DD HH:MM  (contoh: 2025-12-12 02:30)"
  echo
  read -rp "$prompt_msg: " user_input
  user_input="${user_input#"${user_input%%[![:space:]]*}"}"  # trim leading
  user_input="${user_input%"${user_input##*[![:space:]]}"}"  # trim trailing

  if [[ -z "$user_input" ]]; then
    echo "Input kosong — batal."
    return 1
  fi

  # basic validation
  if [[ "$user_input" =~ ^\+[0-9]+[mM]$ ]] || [[ "$user_input" =~ ^[0-9]{2}:[0-9]{2}$ ]] || [[ "$user_input" =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}\ [0-9]{2}:[0-9]{2}$ ]]; then
    SCHEDULE_TIME="$user_input"
    return 0
  else
    echo "Format tidak dikenali. Silakan gunakan salah satu format yang disebutkan."
    return 1
  fi
}

# Tangkap Ctrl+C agar tidak meninggalkan layar aneh
trap 'echo; echo "Dibatalkan."; sleep 1; exit 1' INT

# Main loop
while true; do
  show_menu
  read -rp "Pilih nomor (1-5): " choice
  case "$choice" in
    1)
      parse_time_and_build_cmd "shutdown" "now"
      confirm_and_run "$CMD_DISPLAY" "$CMD_EXEC"
      ;;
    2)
      parse_time_and_build_cmd "reboot" "now"
      confirm_and_run "$CMD_DISPLAY" "$CMD_EXEC"
      ;;
    3)
      if read_schedule_time "Masukkan waktu untuk shutdown"; then
        parse_time_and_build_cmd "shutdown" "$SCHEDULE_TIME"
        confirm_and_run "$CMD_DISPLAY" "$CMD_EXEC"
      else
        read -rp $'\nTekan Enter untuk kembali ke menu...' _
      fi
      ;;
    4)
      if read_schedule_time "Masukkan waktu untuk reboot"; then
        parse_time_and_build_cmd "reboot" "$SCHEDULE_TIME"
        confirm_and_run "$CMD_DISPLAY" "$CMD_EXEC"
      else
        read -rp $'\nTekan Enter untuk kembali ke menu...' _
      fi
      ;;
    5|q|Q)
      echo "Keluar. Sampai jumpa."
      exit 0
      ;;
    *)
      echo "Pilihan tidak valid. Coba lagi."
      sleep 1
      ;;
  esac
done
