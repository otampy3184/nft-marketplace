// SPDX-License-Identifier: Unlicencd
pragma solidity ^0.8.0;

import './ERC721Connector.sol';

contract KryptoBird is ERC721Connector {

    // NFTs保存
    string[] public KryptoBirdz;

    mapping(string => bool) _kryptoBirdzExists;

    function mint(string memory _kryptoBird) public {
        // 既にミントされていないかの判定
        require(!_kryptoBirdzExists[_kryptoBird], 'ERROR: already exists');

        // version違いのため動作せず
        // uint _id = KryptoBirdz.push(_kryptoBird);

        // 手動でLengthを設定
        KryptoBirdz.push(_kryptoBird);
        uint _id = KryptoBirdz.length -1;

        _mint(msg.sender, _id);

        // Mintした場合はExitsをTrueにする
        _kryptoBirdzExists[_kryptoBird] = true;
    }

    // ERC721Metadataからnameとsymbolを継承して渡す
    constructor() ERC721Connector('KryptoBird', 'KBIRDZ') {}


}


