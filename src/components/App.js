import React, { Component } from "react";
import Web3 from "web3";
import detectEthereumProvider from "@metamask/detect-provider";
import KryptoBird from '../abis/KryptoBird.json';

class App extends Component{
    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    // Metamask(とか)の接続確認
    async loadWeb3() {
        const provider = await detectEthereumProvider();
        if (provider) {
            console.log('ethereum wallet is connected')
            window.web3 = new Web3(provider)
        } else {
            console.log('no ethereum wallet detected')
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3
        const accounts = await web3.eth.getAccounts();
        this.setState({account:accounts})
        console.log(this.state.account);
    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            kryptoBirdz: []
        }
    }

    render() {
        return (
            <div>
                <nav className='navbar navbar-dark fixed-top 
                bg-dark flex-md-nowrap p-0 shadow'>
                <div className='navbar-brand col-sm-3 col-md-3 
                mr-0' style={{color:'white'}}>
                        Krypto Birdz NFTs (Non Fungible Tokens)
                </div>
                </nav>
            </div>
        )
    }
}

export default App;