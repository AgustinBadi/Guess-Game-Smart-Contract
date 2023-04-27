# Guess-Game-Smart-Contract

This Plutus smart contract is a guessing game where you can lock funds with a secret and whoever knows the secret can unlock the UTXO. 

The main idea is that one party lock some funds with the sha2-256 hash of the secret and append it to the transaction as an inline datum. The other party can try spend the funds providing the awnser as a redeemer, notice that the awnser has to be encoded from clear text to hexadecimal. Ultimately the validator do a hash of the awnser and if its the same contained on the datum it let the second party unlock the funds. 



