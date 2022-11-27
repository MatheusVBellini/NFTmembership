/**
*  This code was written by Matheus Violaro Bellini from the 
*  Computer Engineering course of the University Of Sao Paulo.
*  
*  It was designed to show a practical application of NFT technology
*  on Blockchains and serves as the final project of a Blockchain 
*  and Cryptocurrencies discipline.
*/

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import './MemberNFT.sol';

contract DAO {
	uint256 public membershipPrice = 1 ether;
	MemberNFT private NFTminter;
	uint256 private DAOfunds;
	
	/**
	*  DAO is deployed together with an instance of the DAO NFT-based membership minter
	*  for handling membership-related transactions.
	*
	*  (DAOfunds assingment is there only for testing)
	*/ 
	constructor() {
		NFTminter = new MemberNFT();
		DAOfunds = 3 ether;
	}

	/**
	*  Used to make functions accessible only for members
	*/
	modifier memberOnly() {
		require(NFTminter.isMember(msg.sender), 'This action is reserved for certified members only');
		_;
	}

	/**
    *  Modifier to guarantee that certain functions can only be called
    *  if there is consensus between DAO contributors.
    *
	*  Since this is only a demonstration, consensus is always true.
	*  In real world applications, it is expected for the DAO to have its 
	*  own consensus protocol clearly defined in its contract.
	*/
    modifier withConsensus() {
        require(true, 'DAO members didnt achieve consensus for the action');
		_;
    }

	/**
	*  Only demonstrative code for showing member-only actions
	*/
	function viewDAOfunds() public view memberOnly returns (uint256) {
		return DAOfunds;
	}

	/**
	* DAO NFT-minter independet function, but with consensus required
	*/
	function changeMembershipPrice(uint256 _membershipPrice) public withConsensus {
		membershipPrice = _membershipPrice;
	}

	/**
	*  Pipeline functions tagged with 'onlyOwner', also applying 
	*  the DAO-specific 'withConsensus' modifier
	*/
	function toggleAcceptNewMembers() public withConsensus {
		NFTminter.toggleMintEnabled();
	}
	function setMaxMembers(uint256 _maxMembers) public withConsensus {
		NFTminter.setMaxMembers(_maxMembers);
	}

	/**
	*  Activates the membership minting process
	*/
	function acquireMembership() public payable {
		NFTminter.mint(msg.sender, msg.value, membershipPrice);
	}
}
