# NEPCon-NECT

Networked exchange for certified timber.

## Info

Enforcing certification standards to ensure sustainable timber utilization along the value chain is complex and inaccurate.

- Only actors are certified by their applied processes
- Manual checking of invoices for volume reconciliation between actors is costly and inefficient
- Multi-material products cannot be certified on a component-level with certainty 
- Even if non-certified wood is detected through volume inconsistencies, the source of it cannot be identified clearly

Thanks to automated, tamper-proven and real-time transaction control, stakeholders gain from superior quality and efficiency
### Prerequisites

[NodeJS](https://nodejs.org/en/), [testrpc](https://github.com/ethereumjs/testrpc), [Truffle](http://truffleframework.com/)


### Installing

Compilation and migration. This deploys the contracts on the blockchain

```
truffle compile && truffle migrate --reset
```

Init scripts links contracts to the manager: 
- Issue 34 tokens of oak from DK to account 0
- Accounts 0, 1, 2 and 3 are certified.

```
truffle exec scripts/init.js
```

### Examples

Trade 4 tokens of oak from account 0 (default account) to account 2
```js
tx = Transaction.at(Transaction.address);
tx.trade(web3.eth.accounts[2], 4, 'oak')
```
## Running the tests

TODO


## Versioning

We use [SemVer](http://semver.org/) for versioning.
