#!/bin/bash

# Inisialisasi angka awal
i=10

# Perulangan countdown
while [ $i -ge 1 ]
do
    echo $i
    i=$((i - 1))
done

# Setelah selesai
echo "GO!"
