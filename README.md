# nft-marketplace
ERC721規格に準拠したTokenを実装し、Reactって画面上からMint~Tokenの取得を行えるサイト

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

