#!/bin/bash

SOURCE_PROGRAM="$1"
echo "compiling program ..."
javac PrologExecutor.java && javac Tokenizer.java

echo "executing  ..."
java PrologExecutor $SOURCE_PROGRAM
