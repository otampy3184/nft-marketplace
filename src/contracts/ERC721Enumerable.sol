// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './ERC721.sol';

contract ERC721Enumerable is ERC721 {

    uint256[] private _allTokens;

    mapping(uint256 => uint256) private _allTokensIndex;

    mapping(address => uint256[]) private _ownedTokens;

    mapping(uint256 => uint256) private _ownedTokensIndex;

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
    function totalSupply() public view returns (uint256){
        return _allTokens.length;
    }

    // Indexに紐づいたTokenを返す
    function tokenByIndex(uint256 _index) external view returns(uint256){
        return _allTokens[_index];
    }

    // indexとOwner情報に紐づいたTokenを返す
    function tokenOfOwnerByIndex(address owner, uint index) public view returns (uint256){
        return _ownedTokens[owner][index];
    }
}