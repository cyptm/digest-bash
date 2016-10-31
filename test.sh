#!/bin/bash

source func.sh

# generate key test
function test_generate {

  generate_key $1

  #assert that public, private, and signature files were generated successfully
  if [ ! -f $PUBLIC_KEY ] || [ ! -f $PRIVATE_KEY ] || [ ! -f $SIGNATURE ]; then
    echo 'Error generating one of the files'
    exit 1
  fi

}

# verify key test
function test_verify_key {
  openssl dgst -SHA256 -verify $PUBLIC_KEY -signature $SIGNATURE $MESSAGE
}

# Execute tests
test_generate "Testmessage"
test_verify_key  
