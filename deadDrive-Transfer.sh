!/bin/bash

# REFERENCES
# - https://stackoverflow.com/q/2388090 -> Delete and replace terminal line
# - https://stackoverflow.com/a/238094  -> An example of the above

# Define the input directory
INPUT_DIR=/home/russdunn/Development/node-docker

# Define the output directory & check if it exists.
# - Directories need to exist for cp to work correctly
# - Remember permissions will be set at execution level
OUTPUT_DIR=/home/russdunn/Development/node-docker-TEST
if [ ! -d "$OUTPUT_DIR" ]; then
  if ! mkdir "$OUTPUT_DIR" ; then
    echo "Something Has Gone Wrong... EXITING (Line 16)"
    exit 1
  fi
fi

# Define a function to retreive the date / time in our format
getDate() { echo "[`date '+%Y-%m-%d %H:%M:%S'`] " ; }

# Retreive how many files are in our directory and populate our variable
# - This ignores hidden files (only linux based with a preceding . )
#### ---------------------------------------------- ####
#### THIS MAY BE A POINT OF FAILURE ON A DEAD DRIVE ####  <--------------------------------
#### ---------------------------------------------- ####
FILECOUNT="$(find $INPUT_DIR -not -path '*/\.*' -type f | wc -l)"
FILEPROGRESS=0
FILEERROR=0


# Define a function to loop through our folder
looper() {
  # This does not expand to hidden files (.) hence
  # the $FILECOUNT argument.
  for f in "$1"/* 
    do
      if [ -d "$f" ]; then
        isDirectory "$f"
        
      elif [ -f "$f" ]; then
        isFile "$f"
        
      else
      
        # Here i was exiting non zero but after the first attempt realised that dead sectors may
        # not even pass the file or folder check. Regardless of if we are a file or folder i am going
        # to error at this point and throw the guilty path into the error log.
        # - Getting tricky we could test in otherways whether it was a folder and then rerun
        #   but that is for a later date & for a much larger fileset.
        #
        # echo "Something has gone wrong... EXITING (Line 41)"
        # echo "- Not a file or directory ($f)"
        # exit 1
        
        echo "`getDate` $f" >> log-FAILURE.log
        ((FILEERROR++))
        
      fi
  done
}

# Define our function for if the value is a file
isFile() {
  echo -ne "\r\e[K" # Wipe the output line clean
  
  STRIPPED=${1#$INPUT_DIR} # Here the path is stripped relative to the INPUT_DIR
                           # SEE - Shell-Parameter-Expansion

  ((FILEPROGRESS++))
  CNT="$(printf "%03d" $FILEPROGRESS)" # Allows formatting of numbers..
                                       # - Ie. 0 becomes 000
  echo -n "[Err{$FILEERROR}][$CNT/$FILECOUNT] $STRIPPED"

  REBUILT=$OUTPUT_DIR$STRIPPED
  if cp "$1" "$REBUILT" 2>> log-FAILURE.log ; then
    echo "`getDate` $STRIPPED" >> log-SUCCESS.log
  else
    echo "`getDate` $STRIPPED" >> log-FAILURE.log
    ((FILEERROR++))
  fi
}

# Define our function for if the value is a directory
isDirectory() {
  # Once again we need to decide if the directory exists in our
  # output folder and if not we need to create it. Only then do
  # we continue execution.
  STRIPPED=${1#$INPUT_DIR}
  REBUILT=$OUTPUT_DIR$STRIPPED
  
  if [ ! -d "$REBUILT" ]; then
    if ! mkdir "$REBUILT" ; then
      echo "Something Has Gone Wrong... EXITING (Line 80)"
      exit 1
    fi
  fi
  looper "$1"
}

# Initialise log file & say hello in the terminal
echo
echo "Russell's Attempt At A FUCKING Sick File Transfer Algorithm..."
echo "- BTW Russ is also know as MARIO KART KING"
echo -e "- MAKE SURE YOU HAVE A TOOHEYS IN HAND (For good luck)..\n\r"

echo -e "`getDate`[SUCCESS LOG] Good thing you had that Tooheys..!\n" > log-SUCCESS.log
echo -e "`getDate`[FAILURE LOG] Mate... Should have had a Tooheys..!\n" > log-FAILURE.log

looper $INPUT_DIR

echo -ne "\r\e[K"
echo -e "\nCompleted with [$FILEERROR] errors."
echo -e "Another shit program supported by Tooheys!\n"
exit 0
