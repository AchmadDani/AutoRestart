#!/bin/bash

clear
echo "==============================="
echo "   PROGRAM MANAJEMEN DAYA"
echo "==============================="
echo "1. Shutdown sekarang"
echo "2. Shutdown terjadwal"
echo "3. Reboot sekarang"
echo "4. Keluar"
echo "==============================="

read -p "Pilih menu (1-4): " pilihan

case "$pilihan" in
    1)
        read -p "Apakah Anda yakin ingin shutdown sekarang? (y/n): " konfirmasi
        if [[ "$konfirmasi" == "y" || "$konfirmasi" == "Y" ]]; then
            echo "Sistem akan dimatikan..."
            sudo shutdown -h now
        else
            echo "Shutdown dibatalkan."
        fi
        ;;
        
    2)
        read -p "Masukkan waktu shutdown (dalam detik): " waktu
        
        if [[ "$waktu" =~ ^[0-9]+$ ]]; then
            if [[ "$waktu" -gt 0 ]]; then
                echo "Sistem akan dimatikan dalam $waktu detik..."
                sudo shutdown -h +"$((waktu/60))"
            else
                echo "Waktu tidak boleh 0 atau kurang."
            fi
        else
            echo "Input tidak valid! Harus berupa angka."
        fi
        ;;
        
    3)
        read -p "Apakah Anda yakin ingin reboot sekarang? (y/n): " konfirmasi
        if [[ "$konfirmasi" == "y" || "$konfirmasi" == "Y" ]]; then
            echo "Sistem akan direboot..."
            sudo shutdown -r now
        else
            echo "Reboot dibatalkan."
        fi
        ;;
        
    4)
        echo "Program keluar."
        exit 0
        ;;
        
    *)
        echo "Pilihan tidak valid!"
        ;;
esac
