#!/bin/bash

clear

echo "================================="
echo "   PROGRAM MANAJEMEN POWER  "
echo "================================="
echo "1. Shutdown sekarang"
echo "2. Shutdown terjadwal"
echo "3. Reboot sekarang"
echo "4. Keluar"
echo "================================="

read -p "Pilih menu [1-4]: " pilihan

case $pilihan in
    1)
        read -p "Apakah Anda yakin ingin shutdown sekarang? (y/n): " konfirmasi
        if [[ $konfirmasi == "y" || $konfirmasi == "Y" ]]; then
            echo "Sistem akan shutdown sekarang..."
            shutdown now
        else
            echo "Shutdown dibatalkan."
        fi
        ;;
        
        2)
        read -p "Masukkan waktu shutdown (dalam detik): " waktu

        if [[ $waktu -lt 0 ]]; then
            echo "❌ Waktu tidak boleh kurang dari 0!"
            exit 1
        fi

        menit=$(( (waktu + 59) / 60 ))

        shutdown -h +$menit

        echo "Sistem akan shutdown dalam $waktu detik."
        echo "Ketik 'c' lalu ENTER untuk membatalkan shutdown."

        read -t $waktu batal

        if [[ $batal == "c" || $batal == "C" ]]; then
            shutdown -c
            echo "✅ Shutdown terjadwal dibatalkan."
        else
            echo "⏳ Waktu habis, shutdown tetap berjalan."
        fi
        ;;
        
    3)
        read -p "Apakah Anda yakin ingin reboot sekarang? (y/n): " konfirmasi
        if [[ $konfirmasi == "y" || $konfirmasi == "Y" ]]; then
            echo "Sistem akan reboot sekarang..."
            reboot
        else
            echo "Reboot dibatalkan."
        fi
        ;;
        
    4)
        echo "Keluar dari program."
        exit 0
        ;;
        
    *)
        echo "❌ Pilihan tidak valid!"
        ;;
esac
