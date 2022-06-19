// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';

// ERC721Metadataを外部に繋げるコントラクト
contract ERC721Connector is ERC721Metadata {

    string [] public kryptoBirdz;
    mapping(string => bool) _kryptoBirdzExists;

    // Mint用
    function mint(string memory _kryptoBird) public {
        require(!_kryptoBirdzExists[_kryptoBird], 'ERROR: kryptoBird already exists');
    }

    // ERC721Connectorをデプロイした際にMetadataを渡す
    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) {

    }
}