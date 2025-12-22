#!/bin/bash

# Ambil jam saat ini (0–23)
jam=$(date +%k)

echo "Sekarang jam $jam"

# Pengondisian berdasarkan waktu
if [ $jam -ge 5 ] && [ $jam -lt 10 ]; then
    echo "Selamat pagi User"
elif [ $jam -ge 10 ] && [ $jam -lt 15 ]; then
    echo "Selamat siang User"
elif [ $jam -ge 15 ] && [ $jam -lt 19 ]; then
    echo "Selamat sore User"
else
    echo "Selamat malam User"
fi
