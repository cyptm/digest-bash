#!/bin/bash

source constants.sh

# Key generator
function generate_key {
  
  # Genearte private key
  openssl ecparam -genkey -name secp256k1 -noout -out $PRIVATE_KEY  &> /dev/null
  #generate corresponding public key
  openssl ec -in $PRIVATE_KEY -pubout -out $PUBLIC_KEY &> /dev/null
  #create sha256 digest of input string and sign it
  echo $1 > $MESSAGE
  openssl dgst -SHA256 -out $DIGEST $MESSAGE &> /dev/null
  openssl dgst -SHA256 -sign $PRIVATE_KEY -out $SIGNATURE $MESSAGE &> /dev/null
 
  #save base64 encoded output to file
  base64 signature > base64_signature

  output_data $1 "$(< base64_signature)" "$(< pubkey.pem)"

}


# Outputs JSON formatted data
function output_data {

 local MESSAGE=$1
 local SIGNATURE=$2
 local PUBKEY=$S3

 echo "{ \"message\" : \""$1"\", \"signature\" : \""$2"\", \"pubkey\" : \""$3"\"}"
}

# Validates input
function validate_input {
  if [ -z "$1" ]; then 
    echo usage: $0 input
    exit
  fi
}

# Main function
function code_challenge {
  
  validate_input $1

  if [ -f $PRIVATE_KEY ] && [ -f $PUBLIC_KEY ] && [ -f $SIGNATURE ]; then
    #save base64 encoded output to file
    base64 $SIGNATURE > $BASE64_SIGNATURE
    output_data $1 "$(< base64_signature)" "$(< pubkey.pem)"
  else
    generate_key $1	
  fi
}


	
