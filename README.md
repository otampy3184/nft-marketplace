# nft-marketplace
ERC721規格に準拠したTokenを実装し、Reactって画面上からMint~Tokenの取得を行えるサイト

# 実行環境
macOs Monterey v12.2.1
Solidity 0.8.0
Node.js v14.15.4
npm v6.14.10
Truffle v5.5.13
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

