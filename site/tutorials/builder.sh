#!/bin/bash
BASE_DIR=site/tutorials/

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=linux;;
    Darwin*)    machine=darwin;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}

## if file is given, generate content for this file
if [[ $1 != "" ]]; then
  ./markymark-bin/markymark-$machine $1
  claat export -ga "UA-133584243-1" ${1/.md/_gen.md}
  exit 0
fi


## if no file is given, check for changed files
git diff --name-only > changedfiles.txt || echo ""
CHANGED_FILES=$(tr '\n' ' ' < changedfiles.txt)

echo "changed files: " $CHANGED_FILES

for filepath in $CHANGED_FILES; do
  #echo $filepath
  newpath="${filepath/$BASE_DIR/}"  
  # only build from root folder and only *.md files (no tutorial-template, no readme)
  if [[ $newpath != *"/"* ]] && [[ $newpath == *".md"* ]] && \
    [[ $newpath != *"_gen.md"* ]] && \
    [[ $newpath != *"tutorial-template.md"* ]] && \
    [[ $newpath != *"README.md"* ]]; then

    echo $newpath
    ./markymark-bin/markymark-$machine $newpath
    claat export -ga "UA-133584243-1" ${newpath/.md/_gen.md}
  fi
done

# now serve the content to check locally
#claat serve
