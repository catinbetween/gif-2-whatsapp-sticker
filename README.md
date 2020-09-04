# gif-2-whatsapp-sticker
A bash script that converts a gif (or a directory of gifs) to whatsapp-friendly webp files

## Requirements
This script is using  *getopts*,  *imagemagick* and *gif2webp*.  Your distro's package manager should provide them.

Don't forget to make the script executable:

`user@shell:  $  chmod +x ./convert_gif.sh`

## Usage
`/convert_gif.sh [OPTIONS]`

### Options
- \-q

	silent mode. Doesn't print any messages except error messages and the final path to the output directory/folder.
- \-v

 	verbode mode. Describes every action that is currently being made.
- \-d /path/to/directory/

  The directory that contains the gifs should be converted.
    ```bash
    user@shell:  $   ./convert_gif.sh -d  /this/is/an/example/directory/
    # Output folder:  /this/is/an/example/directory/converted/
    ``` 
- \-f  /path/to/file

    The file that should be converted.
    ```bash
    user@shell:  $   ./convert_gif.sh -d   /this/is/an/example/directory/foobar.gif
    # Output file:   /this/is/an/example/directory/foobar.webp
    ``` 
## Notes

- \-d and -f can not be used together. Doing so will result in an error message.
- if -q and -v are being used together, -q will be ignored. Script will start in verbose mode.
- if no directory is specified with -d , the default path (scripts' execution path) will be used.
- the script will scan the whole given directory and "try" to convert every file. If a file doesn't have the .gif extension though, it will be skipped. 
