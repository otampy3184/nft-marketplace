// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './ERC721.sol';
import './interfaces/IERC721Enumerable.sol';

contract ERC721Enumerable is IERC721Enumerable, ERC721 {

    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;

    mapping(address => uint256[]) private _ownedTokens;

    mapping(uint256 => uint256) private _ownedTokensIndex;

    // InterfaceID登録
    constructor() {
        _registerInterface(bytes4(
            keccak256('totalSupply(bytes4)')^
            keccak256('tokenByIndex(bytes4)')^
            keccak256('tokenOfOwnerByIndex(bytes4)')
        ));
    }

    // 継承したMint機能を使いNFTをMint、追加で列挙型に情報をPushする
    function _mint(address to, uint256 tokenId) internal override(ERC721) {
        super._mint(to, tokenId);

        // 列挙型にそれぞれ追加
        _addTokensToAllTokenEnumeration(tokenId);
        _addTokensToOwnerEnumeration(to, tokenId);
    }

    // Tokenが追加された時に、AllTokensの列挙型に追加する
    function _addTokensToAllTokenEnumeration(uint256 tokenId) private {
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    // Tokenが追加された時に、OwnerしょゆうTokenの列挙型に追加する
    function _addTokensToOwnerEnumeration(address to, uint256 tokenId) private {
        _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
        _ownedTokens[to].push(tokenId);
    }

    // 全Token数を返す
    function totalSupply() public view override returns (uint256){
        return _allTokens.length;
    }

    // Indexに紐づいたTokenを返す
    function tokenByIndex(uint256 index) external view override returns(uint256){
        require(index < totalSupply(), 'ERC721Enumerable: global index is out of bounds');
        return _allTokens[index];
    }

    // indexとOwner情報に紐づいたTokenを返す
    function tokenOfOwnerByIndex(address owner, uint index) public view override returns (uint256){
        require(index < balanceOf(owner), 'ERC721Enumerable: owner index is out of bounds''');
        return _ownedTokens[owner][index];
    }
}