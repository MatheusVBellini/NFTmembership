// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC721/ERC721.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

/**
*  NFT minting contract designed for DAO membership certification.
*
*  All functions are tagged with 'onlyOwner', since the DAO is the owner
*  of the contract block.
*/
contract MemberNFT is ERC721, Ownable {
    uint256 public numOfMembers;
    uint256 public maxMembers;
    bool public acceptNewMembers;
    mapping(address => bool) public members;

    constructor() payable ERC721('DAO Membership', 'DAO_MEMBERSHIP') {
        maxMembers = 128;
    }

    /**
    *  acceptNewMembers defaults to 'false' when contract is deployed.
    *  Can be used to activate or deactivate the membership minting process.
    */
    function toggleMintEnabled() external onlyOwner {
        acceptNewMembers = !acceptNewMembers;
    }

    /**
    *  Can be used to scale up or down the number of members allowed in the DAO.
    */
    function setMaxMembers(uint256 _maxMembers) external onlyOwner {
        maxMembers = _maxMembers;
    }

    /**
    *  Function for acquiring a NFT membership for the DAO.
    */
    function mint(address buyer, uint256 value, uint256 definedPrice) external payable onlyOwner {
        require(acceptNewMembers, 'DAO is not currently receiving new members');
        require(members[buyer] == false, 'address is already a member');
        require(value == definedPrice, 'value payed is not the value specified for the NFT');
        require(maxMembers > numOfMembers, 'DAO is already at its maximum capacity of members');

        // user passed all the requirements to acquire the NFT membership
        members[buyer] = true;
        numOfMembers++;
        uint256 tokenId = numOfMembers;
        _safeMint(buyer, tokenId); // from ERC721
    }
}
