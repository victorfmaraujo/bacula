#!/bin/bash
#Define Diretório do Bacula
baculadir="/etc/bacula"

#Define arquivo de configuração do Bacula
baculaconf="bacula-dir.conf"

#Cria arquivos de configuração
titles=(Director Console Autochanger Catalog Client Fileset Job JobDefs Messages Pool Profile Schedule Storage Counter)
cd $baculadir
cp ./bacula-dir.conf ./bacula-dir.conf.bak

#Limpar comentários e linhas em branco
cat ./$baculaconf | cut -d '#' -f1 | sed '/^$/d' > ./$baculaconf.temp
cat ./$baculaconf.temp > $baculaconf
rm ./$baculaconf.temp

#Quebrando arquivo de configuração
for i in ${titles[@]} ; do
        mkdir -p confs/$i
		touch confs/$i/$i.conf
        sed -n '/^'$i' {/,/^}/p' $baculaconf > confs/$i/$i.conf
done

#Limpando arquivo de configuração
echo '' > $baculadir/$baculaconf

#Adicionando Parâmetros
for i in ${titles[@]} ; do
	echo '@|"sh -c 'cat $baculadir/confs/$i/*.conf'"' >> $baculaconf
done
exit 0