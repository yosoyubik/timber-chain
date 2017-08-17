import React, { Component } from 'react'
// import SimpleStorageContract from '../build/contracts/SimpleStorage.json'
import Manager from '../build/contracts/Manager.json'
import Transaction from '../build/contracts/Transaction.json'
import getWeb3 from './utils/getWeb3'

import './css/oswald.css'
import './css/open-sans.css'
import './css/pure-min.css'
import './App.css'

class App extends Component {



  constructor(props) {
    super(props)

    this.state = {
      address: '',
      value: '',
      species: '',
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
    //  alert('A name was submitted: ' + this.state.value);
     // Access all state and send to Blockchain

     event.preventDefault();

     const contract = require('truffle-contract');
     const transaction = contract(Transaction);
     transaction.setProvider(this.state.web3.currentProvider);
     console.log(this.state);
     transaction.deployed().then(txinstance => {
         console.log(txinstance);
         this.state.web3.eth.getAccounts((error, accounts) => {
             console.log(accounts);
            //  txinstance.trade(this.state.address, parseInt(this.state.value), this.state.species, {from: accounts[0]});
             txinstance.fakeTrade();
            //  console.log(txinstance.getTokens.call(accounts[0], 'oak', 'DK', {from: accounts[0]}).then(value => {
            //      return value;
            //  }));
             //  tx.trade(web3.eth.accounts[2], 4, 'oak')
         });



     });
   }

  handleChange(event) {
      console.log(event.target.id);
      switch(event.target.id) {
          case 'address':
            this.setState({address: event.target.value});
            break;
          case 'volume':
            this.setState({value: event.target.value});
            break;
          case 'species':
            this.setState({species: event.target.value});
            break;
          default:
              '';
      }
  }


  instantiateContract() {
    /*
     * SMART CONTRACT EXAMPLE
     *
     * Normally these functions would be called in the context of a
     * state management library, but for convenience I've placed them here.
     */


     const contract = require('truffle-contract');
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
        transaction.deployed().then(transactionInstance => {
            console.log(transactionInstance);
            var event = transactionInstance.Trade();
            event.watch((error, result) => {
              if (error) {
                console.log(error);
              }else {
                var buyer = result.args._buyer;
                var seller = result.args._seller;
                var species = this.state.web3.toUtf8(result.args._species);
                var origin = this.state.web3.toUtf8(result.args._origin);
                var valueSeller = result.args.valueSeller;
                var valueBuyer = result.args.valueBuyer;
                console.log(result.args);
                var sellerEntry = [seller, valueSeller, result.args._species, result.args._origin];
                var buyerEntry = [buyer, valueBuyer, result.args._species, result.args._origin];

                this.setState((prevState) => {
                    return {
                        actors: [...prevState.actors, sellerEntry, buyerEntry]
                    }
                });



                // console.log(this.state.web3.toUtf8(species), this.state.web3.toUtf8(origin));
                //
                // transactionInstance.getTokens.call(buyer, species, origin).then( buyerValue => {
                //     var found = false;
                //     for (var i = 0; i < this.state.actors.length; i++) {
                //         if (this.state.actors[i][0] === buyer) {
                //             console.log('buyerValue',buyerValue );
                //             this.state.actors[i][1] = buyerValue;
                //             found = true;
                //         }
                //     }
                //     if (!found) {
                //         // Create new actor
                //         // var actor = buyer;
                //         // var origin = result.args.origin;
                //         // var value = result.args.value;
                //         var actorEntry = [buyer, buyerValue, result.args._species, result.args._origin];
                //         console.log(actorEntry);
                //         this.setState((prevState) => {
                //             return {
                //                 actors: [...prevState.actors, actorEntry]
                //             }
                //         });
                //     }
                //
                //     console.log(this.state.actors);
                //     return transactionInstance.getTokens.call(seller, result.args._species, result.args._origin);
                // }).then(sellerValue => {
                //     var found = false;
                //     this.state.actors.map((i, item) => {
                //         if (item[0] === seller) {
                //             item[i] = sellerValue;
                //             found = true;
                //         }
                //     });
                //     // for (var i = 0; i < this.state.actors.length; i++) {
                //     //     if (this.state.actors[i][0] === seller) {
                //     //         console.log('sellerValue',sellerValue );
                //     //         this.state.actors[i][1] = sellerValue;
                //     //         found = true;
                //     //     }
                //     // }
                //     if (!found) {
                //         // Create new actor
                //         // var actor = seller;
                //         // var origin = result.args.origin;
                //         // var value = result.args.value;
                //         var actorEntry = [seller, sellerValue, result.args._species, result.args._origin];
                //         this.setState((prevState) => {
                //             return {
                //                 actors: [...prevState.actors, actorEntry]
                //             }
                //         });
                //         console.log(this.state.actors);
                //     }
                // });
              }
            });
          });

          manager.deployed().then( managerInstance => {
              var event = managerInstance.IssueTokens();
              event.watch((error, result) => {
                if (error) {
                  console.log(error);
                }else {
                  var actor = result.args._actor;
                  var species = result.args.species;
                  var origin = result.args.origin;
                  var value = result.args.value;
                  var actorEntry = [actor, value, species, origin];
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
          var maxLen = 3;
          var actorAddress = `${item[0].slice(0, 3)}...${item[0].slice(-maxLen, item[0].length-1)}`;
          console.log(item);
          return <tr key={i}><td>{actorAddress}</td><td>{parseInt(item[1])}</td><td>{this.state.web3.toUtf8(item[2])}</td><td>{this.state.web3.toUtf8(item[3])}</td></tr>;
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
                    id='address'
                      name="address"
                      type="text"
                      onChange={this.handleChange} />
                  </label>
                  <br />
                  <label>
                    Volume
                    <input
                    id='volume'
                      name="value"
                      type="number"
                    //   value={this.state.numberOfGuests}
                      onChange={this.handleChange} />
                  </label>
                  <label>
                    Species
                    <input
                    id='species'
                      name="species"
                      type="text"
                    //   value={this.state.numberOfGuests}
                      onChange={this.handleChange} />
                  </label>
                  <input type="submit" value="Trade" />
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
