#!/bin/sh

# $1: input
# $2: output

gpg -o ${1}.decrypted -d ${1}
