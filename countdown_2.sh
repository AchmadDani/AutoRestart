#!/bin/bash

# Cek jumlah argumen
if [ $# -ne 1 ]; then
    echo "penggunaan: countdown_2.sh initial_value"
    exit 1
fi

# Ambil nilai awal dari parameter
angka=$1

# Validasi: pastikan input adalah angka positif
if ! [[ $angka =~ ^[0-9]+$ ]] || [ $angka -le 0 ]; then
    echo "Error: initial_value harus berupa angka positif"
    exit 1
fi

# Countdown
while [ $angka -ge 1 ]
do
    echo $angka
    angka=$((angka - 1))
done

echo "GO!"
