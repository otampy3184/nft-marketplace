// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './interfaces/IERC721Metadata.sol';
import './ERC165.sol';

// NFTとして持つメタデータを持つコントラクト
contract ERC721Metadata is IERC721Metadata, ERC165 {
    string private _name;
    string private _symbol;

    constructor(string memory named, string memory symboled){
        // InterfaceId登録
        _registerInterface(bytes4(
            keccak256('name(bytes4)')^
            keccak256('symbol(bytes4)')
        ));

        _name = named;
        _symbol = symboled;
    }

    function name() external view override returns(string memory){
        return _name;
    }

    function symbol() external view override returns(string memory){
        return _symbol;
    }
}