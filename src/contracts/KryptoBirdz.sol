// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

// ERC721Metadataからnameとsymbolを継承して渡す
constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {}


}


