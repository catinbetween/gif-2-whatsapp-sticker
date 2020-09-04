#!/bin/bash

# NOTE : required packages : getopts, imagemagick,  gif2webp

do_the_magic () {
	
	file=$1
	#collect information about file
	filename=`basename "${file}"` 
	name=$(basename -s .gif "${file}")
	fileext=${filename##*.}

	#setting up target path / file
	targetpath=$2
	targetfile="${targetpath%/}/${name}.webp"
	
	#echo "filename: $filename |  filetext: $fileext | name: $name | targetpath: $targetpath | targetfile : $targetfile"

	#only convert if file is a gif
	if [[ $fileext == "gif" ]]; then
		
		if [[ ! $quiet = 1 ]] || [[ $verbose = 1 ]]; then echo "converting file: $file ..."; fi
		if [[ $$verbose = 1 ]]; then echo "creating temporary file: ${tempfile} "; fi
		
		tempfile="${targetpath%/}/${name}_2.gif"; #echo "tempfile is: $tempfile";
		convert "${file}" -resize 512x512! "${tempfile}"		
		
		if [[ $verbose = 1 ]]; then 
			gif2webp -lossy "${tempfile}" -o "${targetfile}"
		else
			gif2webp -lossy -quiet "${tempfile}" -o "${targetfile}"
		fi
		
		if [[ $$verbose = 1 ]]; then echo "removing temporary file: ${tempfile} "; fi
		rm "${tempfile}"
		
	else
		if [[ ! $quiet = 1 ]] || [[ $verbose = 1 ]]; then echo "file $file is not a gif. skipping.."; fi
	fi
}
# prepare argument variables
verbose=0
quiet=0
directory=`pwd` #current directory
file=false
errors=""

while getopts "qvcd:f:" opt; do
    case "$opt" in
    q)	quiet=1
        ;;
    v)  verbose=1
        ;;
    d)  directory=${OPTARG%/};
    	if [[ ! -d ${directory} ]]; then echo "directory does not exist: ${directory}";exit; fi
        ;;
    f)  file=$OPTARG;
    	if [[ ! -f "${directory%/}/${file}" ]]; then echo "file does not exist: ${directory%/}/${file}"; exit; fi
    	file=`basename "${file}"`
        ;;
    *)  exit 1 # when syntax is wrong
    ;;
    esac
done

# next argument
shift $((OPTIND-1)) 
[ "${1:-}" = "--" ] && shift

# check argument integrity
if [[ $@ ]]; then
	echo "unrecognized parameters: $@"
	exit
fi
if [[ ! $file = false ]] && [[ ! $(pwd) = $directory ]];then
	echo "option -f cannot be provided together with option -d"
	exit;
fi
if [[ $quiet = 1 ]] && [[ $verbose = 1 ]];then
	echo "argument -q (silent mode) and -v (verbose mode) have been given. Going into verbose mode...."
fi


# if a file was provided, just convert the file ( file was checked to exist earlier)
if [[ ! $file = false ]]; then 
	do_the_magic "${directory%/}/$file" ${directory}
	echo "gif was converted to ${directory}/$(basename -s .gif "${file}").webp"
else # go through the directory and convert every gif

	# create a folder for converted gifs if it doesn't exist yet
	if [[ ! -d "${directory%/}/converted" ]]
	then
		if [[ $verbose = 1 ]]; then echo "creating folder ./created/ in ${currentpath}..."; fi 
    		mkdir "${directory%/}/converted"
	fi
	
	# find all files in directory and convert it
	files=$(find "${directory}" -maxdepth 1)
	for pic in $files; do
		
		pic=`basename "${pic}"`		
		do_the_magic "${directory%/}/${pic}" "${directory%/}/converted/"
  		res1=$?
  				
		if [[ ! $res1 = 0 ]]; then 
			echo "program couldn't finish"
			exit 1
		fi
	done
	echo "gifs were converted to webp in ${directory%/}/converted"
fi
