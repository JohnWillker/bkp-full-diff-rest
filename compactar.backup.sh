#!/bin/bash

echo "Script de compactação"
DSTDIR=/backup/difer

DATAIN=`date +%c`
echo "Data de inicio: $DATAIN"

gzip -9 $DSTDIR/*.tar

echo "Compactação concluída"
DATAFIN=`date +%c`
echo "Data de termino: $DATAFIN"
echo "Compactação concluída"
echo "INICIO: $DATAIN" >> /var/log/backup_compactacao.log
echo "FIM: $DATAFIN" >> /var/log/backup_compactacao.log
echo "Realizado pelo usuário: $USER" >> /var/log/backup_compactacao.log
echo "-----------------------------------" >> /var/log/backup_compactacao.log
echo "Log gerado em /var/log/backup_compactacao.log"

exit 0
