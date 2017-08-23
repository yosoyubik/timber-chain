
# Compilation and migration. This deploys the contracts on the blockchain
truffle compile && truffle migrate --reset

# Init scripts links contracts to the manager 
# Issue 34 tokens of oak from DK to account 0
# Accounts 0, 1, 2 and 3 are certified.
truffle exec scripts/init.js

# We start the console and play around.
truffle console
