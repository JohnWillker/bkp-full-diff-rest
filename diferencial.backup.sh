#!/bin/bash
echo "Programa de Backup Diferencial"
echo " "

dadosdif() {

SRCDIR="/dados/" #diretórios que serão feitos backup
DSTDIR=/backup/difer #diretório de destino do backup
DATA=`date +%d-%m-%Y`
TIME_FIND=-720 #+xx busca arquivos criados existentes a xx minutos (arquivos que tenham mais de xx minutos)
#-xx arquivos que tenham sido criados nos últimos xx minutos
#12 horas = 720 minutos 8horas 480 minutos
TIME_DEL=+7   # dias em que permanecera o backup diferencial armazenado

#criar o arquivo dif-data.tar no diretório de destino
ARQ=$DSTDIR/dif-$DATA.tar
#data de inicio backup
DATAIN=`date +%c`
echo " Data de inicio: $DATAIN"

}

backupdif(){
sync

find $SRCDIR -type f -cmin $TIME_FIND -exec tar -rvf $ARQ {} ";"

if [ $? -eq 0 ] ; then
   echo "--------------------------------------"
        echo "Backup Diferencial concluído com sucesso"
   DATAFIN=`date +%c`
   echo "Data de termino: $DATAFIN"
   echo "Backup realizado com sucesso" >> /var/log/backup_diferencial.log
   echo "Criado pelo usuário: $USER" >> /var/log/backup_diferencial.log
   echo "INICIO: $DATAIN" >> /var/log/backup_diferencial.log
   echo "FIM: $DATAFIN" >> /var/log/backup_diferencial.log
   echo "------------------------------------------------" >> /var/log/backup_diferencial.log

   echo "Backup realizado com sucesso
Criado pelo usuário: $USER
INICIO: $DATAIN
FIM: $DATAFIN
------------------------------------------------" > /backup/log/diferencial.log
   echo " "
   echo "Log gerado em /var/log/backup_diferencial.log e /backup/log/diferencial.log"

else
   echo "ERRO! Backup Diferencial $DATAIN" >> /var/log/backup_diferencial.log
fi
}

procuraedestroidif(){

#apagando arquivos mais antigos (a 7 dias que existe (-cmin +2)
find $DSTDIR -name "dif*" -ctime $TIME_DEL -exec rm -f {} ";"
   if [ $? -eq 0 ] ; then
      echo "Arquivo de backup mais antigo eliminado com sucesso!"
   else
      echo "Erro durante a busca e destruição do backup antigo!"
   fi
}

dadosdif
backupdif
procuraedestroidif

bash /backup/compactar.backup #chama e roda o script de compactação de backup
python /backup/send_email_difer.py
exit 0
