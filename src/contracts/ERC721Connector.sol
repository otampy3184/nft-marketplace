// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './ERC721Metadata.sol';
import './ERC721.sol';

// ERC721Metadataを外部に繋げるコントラクト
contract ERC721Connector is ERC721Metadata, ERC721 {

    // ERC721Connectorをデプロイした際にMetadataを渡す
    constructor(string memory name, string memory symbol) ERC721Metadata(name, symbol) {

    }
}