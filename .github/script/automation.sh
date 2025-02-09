#!/bin/bash

origem="devops/garapua/ARQUIVOS/"
destino="devops/garapua/ARQUIVOS_PROCESSADOS/"

# Move e renomeia os arquivos
for arquivo in "$origem"/*; do
    if [ -f "$arquivo" ]; then
        timestamp=$(date +"%Y%m%d_%H%M%S")
        nome_arquivo=$(basename "$arquivo")
        novo_nome="${timestamp}_${nome_arquivo}"
        mv "$arquivo" "$destino/$novo_nome"
        echo "Movido: $arquivo -> $destino/$novo_nome"
    fi
done