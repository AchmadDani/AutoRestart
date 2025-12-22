#!/bin/bash

# Meminta input dari user
echo "Masukkan angka:"
read angka

echo "Mulai countdown!"

# Perulangan countdown berdasarkan input user
while [ $angka -ge 1 ]
do
    echo $angka
    angka=$((angka - 1))
done

# Setelah selesai
echo "GO!"
