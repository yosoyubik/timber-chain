import React, { Component } from 'react'
// import SimpleStorageContract from '../build/contracts/SimpleStorage.json'
import Manager from '../build/contracts/Manager.json'
import Transaction from '../build/contracts/Manager.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {
  constructor(props) {
    super(props)

    this.state = {
      storageValue: 0,
      web3: null,
      actors : []
    }

    this.handleSubmit = this.handleSubmit.bind(this);
    this.handleChange = this.handleChange.bind(this);

  }

  componentWillMount() {
    // Get network provider and web3 instance.
    // See utils/getWeb3 for more info.
    window.web3 = undefined;
    getWeb3
    .then(results => {
      this.setState({
        web3: results.web3
      })
      console.log(this);
      // Instantiate contract once web3 provided.
      this.instantiateContract()
    })
    .catch(() => {
      console.log('Error finding web3.')
    })
  }


  handleSubmit(event) {
     alert('A name was submitted: ' + this.state.value);
     event.preventDefault();
   }

  handleChange(event) {
      console.log(event.target);
    this.setState({value: event.target.value});
  }


  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */

    const contract = require('truffle-contract')
    const manager = contract(Manager);
    const transaction = contract(Transaction);
    manager.setProvider(this.state.web3.currentProvider);
    transaction.setProvider(this.state.web3.currentProvider);

    // tx.hasTokens.call(web3.eth.accounts[4], 'oak', 34)


    // console.log(manager);
    // simpleStorage.setProvider(this.state.web3.currentProvider)

    // Declaring this for later so we can chain functions on SimpleStorage.
    // var simpleStorageInstance

    // Get accounts.
    this.state.web3.eth.getAccounts((error, accounts) => {
        // transaction.deployed().then(transactionInstance => {
        //     var event = transactionInstance.NewSample();
        //     event.watch((error, result) => {
        //       if (error) {
        //         console.log(error);
        //       }else {
        //         var digest = multihash.fromHexString(result.args._ipfshash.replace('0x', ''));
        //         var code = parseInt(result.args._hashFunc, 10);
        //         var length = parseInt(result.args._length, 10);
        //         var address = result.args._from;
        //         console.log(digest, code, length);
        //         var ipfsPath = bs58.encode(multihash.encode(digest, code, length));
        //         this.setState((prevState) => {
        //             return {
        //                 samples: [...prevState.samples, [address, ipfsPath]]
        //             }
        //         });
        //       }
        //     });
        //   });

          manager.deployed().then( managerInstance => {
              console.log(managerInstance);
              var event = managerInstance.IssueTokens();
              event.watch((error, result) => {
                if (error) {
                  console.log(error);
                }else {
                  var actor = result.args._actor;
                  var species = result.args.species;
                  var origin = result.args.origin;
                  var value = result.args.value;
                  var actorEntry = [actor, species, origin, value];
                  this.setState((prevState) => {
                      return {
                          actors: [...prevState.actors, actorEntry]
                      }
                  });
                }
              });
          });


    //   simpleStorage.deployed().then((instance) => {
    //     simpleStorageInstance = instance
      //
    //     // Stores a given value, 5 by default.
    //     return simpleStorageInstance.set(5, {from: accounts[0]})
    //   }).then((result) => {
    //     // Get the value from the contract to prove it worked.
    //     return simpleStorageInstance.get.call(accounts[0])
    //   }).then((result) => {
    //     // Update state with the result.
    //     return this.setState({ storageValue: result.c[0] })
    //   })
    });
  }

  render() {
      console.log(this.state);
      const list = this.state.actors.map((item, i) => {
          console.log(item[1]);
          var maxLen = 3;
          var actorAddress = `${item[0].slice(0, 3)}...${item[0].slice(-maxLen, item[0].length-1)}`;
          return <tr key={i}><td>{actorAddress}</td><td>{this.state.web3.toUtf8(item[1])}</td><td>{this.state.web3.toUtf8(item[2])}</td><td>{parseInt(item[3])}</td></tr>;
      });
    return (
      <div className="App">
        <nav className="navbar pure-menu pure-menu-horizontal">
            <a href="#" className="pure-menu-heading pure-menu-link">Truffle Box</a>
        </nav>

        <main className="container">
          <div className="pure-g">
            <div className="pure-u-1-1">
              <h1>Timber Chain</h1>
              <table>
                  <thead>
                    <tr>
                      <th>Address</th>
                      <th>Token value</th>
                      <th>Species</th>
                      <th>Origin</th>
                    </tr>
                  </thead>
                  <tbody>
                    {list}
                  </tbody>
              </table>

              <div>
              <form onSubmit={this.handleSubmit}>
                  <label>
                    Address
                    <input
                      name="address"
                      type="text"
                      onChange={this.handleChange} />
                  </label>
                  <br />
                  <label>
                    Volume
                    <input
                      name="value"
                      type="number"
                    //   value={this.state.numberOfGuests}
                      onChange={this.handleChange} />
                  </label>
                  <label>
                    Species
                    <input
                      name="species"
                      type="text"
                    //   value={this.state.numberOfGuests}
                      onChange={this.handleChange} />
                  </label>
                  <input type="submit" value="Submit" />
                </form>

              </div>

            </div>

          </div>
        </main>
      </div>
    );
  }
}

export default App
