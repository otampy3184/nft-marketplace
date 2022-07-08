# nft-marketplace
ERC721規格に準拠したTokenを実装し、フロント上からMintを行い、Tokenの閲覧までを行えるWebアプリケーション

# 環境
macOS Monterey v12.2.1
Solidity 0.8.0
React.js v16.8.5
Node.js v14.15.4
npm v6.14.10
Truffle v5.5.13
Truffle HDWalletProvider v2.0.8
Openzeppelin Contract v4.6.0

# 確認方法
初期設定
```
% git clone github.com/otampy3184/nft-marketplace
% cd nft-marketplace
% npm install
```

プライベートネットワーク設定
[Ganache](https://trufflesuite.com/ganache/)の公式サイトへ行き、利用OSに合わせたGanacheのアプリケーションをインストールする
インストールが完了したらQuick Startでネットワークを立ち上げる
![quickstart](https://trufflesuite.com/img/docs/ganache/ganache-home-empty.png)
ネットワークの立ち上げに成功した場合、↓のような画面が見える
![network](https://trufflesuite.com/img/tutorials/pet-shop/ganache-initial.png)
画面上部真ん中付近に表示されているのがEthereumのプライベートネットワークの立ち上げ場所なのでtruffle-config.jsを書き換えてここを向くように書き換える

truffle-config.jsのnetwork部分がganecheの立ち上げ場所を向いているかどうかの確認
```javascript
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
  }
```

truffle consoleを立ち上げてGanacheとの接続確認を行う
```
% truflfle console
(development)>
```

コントラクトのコンパイルを行う
```
% truffle compile --all
```

コントラクトをネットワークにデプロイする
```
% truffe migrate --network development
```

React側を立ち上げる
```
% npm run start
```
立ち上げ後はローカルホスト上にNFT marketplaceが立ち上がる

トランザクションはMetamaskに登録したGanache上のアカウントを指定する
送信先のアドレスはデプロイしたコントラクトアドレスになっている
初期状態ではコントラクトアドレスの残高は0となっておりフロントエンド上の表示も0になっているが、トランザクションの承認を行うと残高が追加される

追加された残高は以下の部分を通じてチェーン上からフロントエンド上に渡されている
```javascript
    // Stores a given value, 5 by default.
    await contract.methods.set(5).send({ from: accounts[0] });

    // Get the value from the contract to prove it worked.
    const response = await contract.methods.get().call();

    // Update state with the result.
    this.setState({ storageValue: response });
```

setState()によってresponseに入っているvalue値が格納され、HTML上に表示される
```html
        <div>The stored value is: {this.state.storageValue}</div>
```



# やること
1. ERC721のMetadataに対応
2. TokenURIを設定できるようにする
3. 設定したTokenURIから画像データを取得できるようにする
4. App.js上で取得したメタデータについている画像データを表示できるよう対応する

# ERC721についてメモ
* ERC721を継承しただけではMetadataとかの機能はつかない
* Metadataに対応したい場合はERC721Tokenをさらに継承する必要がある
* 継承の順序としては以下
```
    ERC721Basic => ERC721BasicToken => ERC721 => ERC721Token
```
* ↑ERC721の時点でMetadataとEnumerableを継承済みなので、ERC721Tokenこそが継承すべきもの
* ↑ERC721Tokenは既に存在せず、ERC721として統合されている模様
```
    ERC721Enumerable　┰-- IERC721Enumerable
                    　┗-- ERC721 ┰--- IERC721          
                               　┣-- IERC721Metadata  
                            　   ┣-- IERC721Receiver 
                            　   ┣-- Address          
                            　   ┣-- Context          
                            　   ┣-- String           
                            　   ┗-- ERC165  
```

# 0->1
truffleをインストールし、truffleプロジェクトを作成する
```
$ npm install -g truffle
$ truffle init
```

Openzeppelinで使うコントラクトのパッケージをインストールする
```
$ npm install @openzeppelin/contracts
```

テスト用のコントラクトを作成
```javascript
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../node_modules/@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "../node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";

contract RedditAvatar is ERC1155 {
    using COunters for Counters.Couter;
    Counters.Counter private _tokenCounter;

    uint256 public constant SAVATHUN = 1;
    uint256 public constant DEER = 2;

    string baseMetadataURIPrefix;
    string baseMetadataURISuffix;

    // コンストラクタで初期値を設定
    constructor() ERC1155(""){
        baseMetadataURIPrefix = "gs://my-reddit-avatar.appspot.com/reddit-avatar.png";
        baseMetadataURISuffix = ".json?alt=media";

        _mint(msg.sender, SAVATHUN, 100, "");
    }
    
    // 指定量をmsg.senderに対してmintする実装(親機能呼び出し)
    function mint(uint256 _id, uint256 _amount) public {
        _mint(msg.sender, _id, _amount, "");
    }

    // mint()のバッチ処理版
    function mintBatch(uint256[] _ids, uint256[] _amounts) public {
        _mintBatch(msg.sender, _ids, _amounts, "");
    }

    // URIを後から書き換える用
    function setMetadataURI(string memory _prefix, string memory _suffix) public {
        baseMetadataURIPrefix = _prefix;
        baseMetadataURISuffix = _suffix;
    }   
}
```

マイグレート用のファイルも作成する
```javascript
    const Migrations = artifacts.require("RedditAvatar");

    module.exports = function (deployer) {
        deployer.deploy(Migrations);
    };  
```

hdwallet providerもインストールしておく
```
$ npm install @truffle/hdwallet-provider --save-dev
```

truffleの向き先がrinkebyに向くようにtruffle-config.jsを編集する
mnemonicには自身で設定したInfuraの鍵を設定しておく（外部公開は注意）
```javascript
    const HDWalletProvider = require('@truffle/hdwallet-provider');
    const mnemonic = "MY METAMASK MEMONIC";

    rinkeby: {
    provider: () => new HDWalletProvider(mnemonic, `https://rinkeby.infura.io/v3/MY_ACCESS_TOKENa`),
    network_id: 4,       // Rinkeby's id
    gas: 5500000,        // Rinkeby has a lower block limit than mainnet
    confirmations: 2,    // # of confs to wait between deployments. (default: 0)
    timeoutBlocks: 200,  // # of blocks before a deployment times out  (minimum/default: 50)
    skipDryRun: true     // Skip dry run before migrations? (default: false for public nets )
    },
```

コントラクトのコンパイルとデプロイを行う
```
$ truffle compile
$ truffle migrate --network rinkeby
~~~
2_reddit_avatar.js
==================

   Deploying 'RedditAvatar'
   ------------------------
   > transaction hash:    0x3db993499e0e2f489722fa876caecfa221f29b58006182b045bcd423dc11455e
   > Blocks: 1            Seconds: 9
   > contract address:    0x06B7aD5FaA54Ea5923aA10A1e4e6E7229A46cac5
   > block number:        10633597
   > block timestamp:     1651910332
   > account:             0xBE5a600FB461C78F0B262b410A7bd66545cd1C50
   > balance:             0.354509998747331663
   > gas used:            2751709 (0x29fcdd)
   > gas price:           12.458553041 gwei
   > value sent:          0 ETH
   > total cost:          0.034282312529897069 ETH

   Pausing for 2 confirmations...

   -------------------------------
   > confirmation number: 1 (block: 10633598)
   > confirmation number: 2 (block: 10633599)
   > Saving migration to chain.
   > Saving artifacts
   -------------------------------------
   > Total cost:     0.034282312529897069 ETH

Summary
=======
> Total deployments:   2
> Final cost
:          0.037272316152011469 ETH
```