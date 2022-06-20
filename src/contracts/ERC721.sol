// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './libraries/Counters.sol';
import './ERC165.sol';
import './interfaces/IERC721.sol';

/**
Mint機能について
    a. 各NFTがは定のAddressを指すこと
    b. TokenIDトラックすること
    c. TokenOwnerAddressとTokenIDSをトラックすること
    d. 特定のAddressがどのTokenIDを持っているかトラックすること
    e. Transferされた時にコントラクトAddressとどこにMintされたのかEmitすること
 */

contract ERC721 is ERC165, IERC721 {

    //event Transfer(address from, address to, uint256 tokenId);

    // TokenIDとOwnerアドレスをマッピング
    mapping(uint256 => address) private _tokenOwner;

    mapping(address => uint256) private _OwnedTokensCount;

    // TokenIDとApprovedアドレスをマッピング
    mapping(uint256 => address) private _tokenApprovals;

    // InterfaceIdの登録
    constructor() {
        _registerInterface(bytes4(
            keccak256('balanceOf(bytes4)')^
            keccak256('ownerOf(bytes4)')^
            keccak256('transferFrom(bytes4)')
        ));
    }

    // 指定アドレスがいくつNFTを所有しているか
    function balanceOf(address _owner) public override view returns(uint256) {
        require(_owner != address(0), 'ERC721: owner query for zero address');
        return _OwnedTokensCount[_owner];
    }

    // 指定トークンの所有者アドレスを返す
    function ownerOf(uint256 _tokenId) public override view returns(address){
        address owner = _tokenOwner[_tokenId];
        // require(_exists(_tokenId), 'ERC721: token doesnt exist');
        // return _tokenOwner[_tokenId];
        // 下が正しい？

        require(owner != address(0), 'ERC721: token doesnt exist');
        return owner;
    }

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

    function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
        require(_to != address(0), 'dont transfer to zero address');
        require(ownerOf(_tokenId) == _from, 'cannot transfer to own address');

        // 指定IDのTokenの所有者をToに書き換え
        _tokenOwner[_tokenId] = _to;

        emit Transfer(_from, _to, _tokenId);
    }

    function transferFrom(address _from, address _to, uint256 _tokenId) public override{
        _transferFrom(_from, _to, _tokenId);
    }
}