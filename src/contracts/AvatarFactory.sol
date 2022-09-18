// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// openzeppelinのコントラクトをimport
import "../../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Counters.sol";

contract MyNFT is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("Avatarz", "AVT"){}

    // NFTの新規発行
    function createAvatar (string memory _tokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint newTokenId = _tokenIds.current();
        _mint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);

        return newTokenId;
    }

    // NFTの移転
    function transferAvatar (address to, uint256 tokenId) public onlyOwner {
        require(ownerOf(tokenId) != to, "you cannot transfer your own Avatar");
        _safeTransfer(msg.sender, to, tokenId, "");
    }

}
