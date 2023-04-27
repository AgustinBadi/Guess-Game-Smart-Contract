#!/bin/bash

assets=/home/ash/Cardano/experiments/guessname/assets
keypath=/home/ash/Cardano/wallets/preview
name="$1"
txin="$2"
body="$assets/guessD.txbody"
tx="$assets/guessD.tx"

# Build gift address 
cardano-cli address build \
    --payment-script-file "$assets/guess.plutus" \
    --testnet-magic 2 \
    --out-file "$assets/guess.addr"

# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "$txin" \
    --tx-out "$(cat "$assets/guess.addr") + 55000000 lovelace" \
    --tx-out-inline-datum-file "$assets/secretNameDatum.json" \
    --change-address "$(cat "$keypath/$name.addr")" \
    --out-file "$body"
    
# Sign the transaction
cardano-cli transaction sign \
    --tx-body-file "$body" \
    --signing-key-file "$keypath/$name.skey" \
    --testnet-magic 2 \
    --out-file "$tx"

# Submit the transaction
cardano-cli transaction submit \
    --testnet-magic 2 \
    --tx-file "$tx"

tid=$(cardano-cli transaction txid --tx-file "$tx")
echo "transaction id: $tid"
echo "Cardanoscan: https://preview.cardanoscan.io/transaction/$tid"