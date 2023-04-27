{-# LANGUAGE DataKinds           #-}
{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE NoImplicitPrelude   #-}
{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE TemplateHaskell     #-}


module GuessName where

import qualified  Plutus.V2.Ledger.Api as PlutusV2
import            PlutusTx                (BuiltinData, compile, fromBuiltinData, toBuiltinData)
import            PlutusTx.Prelude        (sha2_256, otherwise, traceError, (==),($),(.))
import            PlutusTx.Maybe          (fromMaybe)
import            PlutusTx.Builtins       (mkB)
import            Prelude                 (IO)
import            Utilities               (writeValidatorToFile, writeDataToFile, bytesFromHex)


{-# INLINABLE mkGuessValidator #-}
mkGuessValidator :: BuiltinData -> BuiltinData -> BuiltinData -> ()
mkGuessValidator dat red _
 | dat == hashedRedeemer red = ()
 | otherwise                 = traceError "Wrong guess! :("
 where 
    hashedRedeemer :: BuiltinData -> BuiltinData
    hashedRedeemer = toBuiltinData . sha2_256 . fromMaybe "" . fromBuiltinData 

validator :: PlutusV2.Validator
validator = PlutusV2.mkValidatorScript $$(PlutusTx.compile [|| mkGuessValidator ||])

---------------------------------------------------------------------------------------------------
------------------------------------- HELPER FUNCTIONS --------------------------------------------

-- Writes the script to path
saveVal :: IO ()
saveVal = writeValidatorToFile "./assets/guess.plutus" validator

-- TODO: Writes the data on JSON format to path
-- mkData path msg = writeDataToFile path $ mkB $  PlutusV2.toBuiltin $ bytesFromHex msg 
-- Inline Datum (secret): Needs a sha2-256 hash of the secret as input. 
-- Redeemer (awnser): Need a hexadecimal string as an input



