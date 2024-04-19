#!/bin/bash
origen=""
destino=""
tamanio=""
flag=true

while getopts "o:d:t:" option; do
	case "$option" in 
		o) origen=${OPTARG};;
		d) destino=${OPTARG};;
		t) tamanio=${OPTARG};;
	esac
done

if [ ! $origen ]; then
	origen=`zenity --file-selection --directory --title="Contame en que carpeta estan las imagenes que queres achicar"`;
fi

if [ ! $destino ] && [ $origen ]; then
	destino=`zenity --file-selection --directory --title="Contame donde te sirve que te deje las imagenes"`;
fi

if [ ! $tamanio ] && [ $origen ] && [ $destino ]; then
	tamanio=`zenity --scale --text="Cuanto queres que te las achiquemos, maestro?"`;
fi

if [ ! -d $origen ]; then
	flag=false;
	echo "Che, fijate que no existe el origen";
fi

if [ $tamanio ] && ( [[ $tamanio > 100 ]] || [[ $tamanio < 0 ]] ); then
	flag=false;
	notify-send "Este es el imageAchicator, father. If te pinta, make bigger unas images, buscate el imageAgrandator"; 
fi

if [ ! $tamanio ] || [ ! $origen ] || [ ! $destino ]; then
	flag=false;
fi

if $flag ; then
	if [ ! -d $destino/imagenes-achicadas ]; then
		mkdir $destino/imagenes-achicadas;
	fi
	for f in $origen/*.jpg ; do
    		convert $f -resize $tamanio% $destino/imagenes-achicadas/${f##*/};
	done
	notify-send "Imagenes achicadas";
	open $destino/imagenes-achicadas;
fi
