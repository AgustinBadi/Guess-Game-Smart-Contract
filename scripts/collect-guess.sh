#!/bin/bash

assets=/home/ash/Cardano/experiments/guessname/assets
keypath=/home/ash/Cardano/wallets/preview
name="$1"
collateral="eff86846f473e7ce562e6871b883ee49d42006ae7b15eff2d0e5ffb3baeb3661#1"
txin="ded800746f9c12e90d6d55ddb4667bc5a2169cfdb2c01b30f934396fd4ebb337#0"

pp="$assets/protocol-parameters.json"
body="$assets/guessC.txbody"
tx="$assets/guessC.tx"

# Query the protocol parameters \

cardano-cli query protocol-parameters \
    --testnet-magic 2 \
    --out-file "$pp"

# Build the transaction
cardano-cli transaction build \
    --babbage-era \
    --testnet-magic 2 \
    --tx-in "$txin" \
    --tx-in-script-file "$assets/guess.plutus" \
    --tx-in-inline-datum-present \
    --tx-in-redeemer-file "$assets/correctAwnser.json" \
    --tx-in-collateral "$collateral" \
    --change-address "$(cat "$keypath/$name.addr")" \
    --protocol-params-file "$pp" \
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

