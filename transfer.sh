#!/bin/bash

httpSingleUpload()
{
    response=$(curl -A curl --upload-file "$1" "https://transfer.sh/$2") || { echo "Failure!"; return 1;}
    printUploadResponse
}

printUploadResponse()
{
fileID=$(echo "$response" | cut -d "/" -f 4)
  cat <<EOF
Transfer File URL: $response
EOF
}

singleUpload() {
  filePath=$(echo "$1" | sed s:"~":"$HOME":g)
  if [ ! -f "$filePath" ]; then {
    echo "Error: invalid file path"
    return 1
  }; fi
  tempFileName=$(echo "$1" | sed "s/.*\///")
  echo "Uploading $tempFileName"
  httpSingleUpload "$filePath" "$tempFileName"
}


singleDownload()
{
  filePath=$(echo "$2" | sed 's/\.\///g')
  
  if [ ! -d "$filePath" ]
  then
    mkdir "$filePath"
   # echo "create $filePath"	    
  fi
  
  echo "Downloading $3"
  response=$(curl -# --url "https://transfer.sh/$3/$4" --output "$filePath/$4")
  printDownloadResponse
}

printDownloadResponse()
{
  fileID=$(echo "$response" | cut -d "/" -f 4)
  cat <<EOF
Success! $fileID
EOF
}



x=$(
   cat <<EOF
Description: Bash tool to transfer files from the command line.
Usage:
  -d  ...
  -h  Show the help ... 
  -v  Get the tool version
Examples:
  <Write a couple of examples, how to use your tool>
  ./transfer.sh test.txt ...
EOF
)
 
service () {
  if [[ $1 == "-h" ]];
  then echo "$x"
  elif [[ $1 == "-v" ]];
  then echo "1.23.0"
  elif [[ $1 == "-d" ]]
  then singleDownload "$@"
  else 
  singleUpload "$@"
  fi
}

service "$@"

