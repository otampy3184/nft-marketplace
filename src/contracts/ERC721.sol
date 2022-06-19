// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './libraries/Counters.sol';

/**
Mint機能について
    a. 各NFTがは定のAddressを指すこと
    b. TokenIDトラックすること
    c. TokenOwnerAddressとTokenIDSをトラックすること
    d. 特定のAddressがどのTokenIDを持っているかトラックすること
    e. Transferされた時にコントラクトAddressとどこにMintされたのかEmitすること
 */

contract ERC721 {

    event Transfer(address from, address to, uint256 tokenId);

    // TokenIDとOwnerアドレスをマッピング
    mapping(uint256 => address) private _tokenOwner;

    mapping(address => uint256) private _OwnedTokensCount;

    // TokenIDとApprovedアドレスをマッピング
    mapping(uint256 => address) private _tokenApprovals;

    // Tokenの存在を確認
    function _exists(uint256 tokenId) internal view returns(bool){
        address owner = _tokenOwner[tokenId];
        // アドレスが存在していることを確認
        return owner != address(0);
    }

    // 新規にNFTを指定のアドレスに対してMintする
    function _mint(address to, uint256 tokenId) internal virtual {
        // Zeroアドレスに対してミントしようとしていないか確認
        require(to != address(0), 'ERC721: minting zero address');
        // すでにTokenがミントされていないか確認
        require(!_exists(tokenId), 'ERC721: token is already minted');

        // TokenのOwnerをToにする
        _tokenOwner[tokenId] = to;
        // Toアドレスの所有トークン数をインクリメント
        _OwnedTokensCount[to] += 1;

        // Event発行
        emit Transfer(address(0), to, tokenId);
    }
}