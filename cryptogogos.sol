// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/solc-0.6/contracts/access/Ownable.sol";


contract CryptoGogos is Ownable, ERC721 {

using Counters for Counters.Counter;
Counters.Counter private _tokenIds; //Counter is a struct in the Counters library

// mapping(uint =>Cards) public tokeninfo;
mapping(uint=>string) public tokenURIS;
uint constant private maxSupply =7777;
address _address;

constructor() ERC721("GOGOS", "GOG") public {
_address = msg.sender;
}
struct CardType {
uint256 typeId;
string cid;
uint256 tier;
Counters.Counter serialCounter;
}

struct Card {
uint256 typeId;
uint256 price;
uint256 serial;
uint256 prevPrice;
}

struct Draw {
address recipient;
uint256 drawCost;
}
// queryId -> Draw
mapping(bytes32 => Draw) private _inflightDraws;
// typeId -> CardType
mapping(uint256 => CardType) private _types;
uint256 private typeCount;

Counters.Counter private _tokenIdTracker;
// token -> card

mapping(uint256 => Card) private _cards;


/*recepient is the address of the person who will receive nft
hash is IPFS hash associated with nft
metadata is link to json
*/
function getCard(address recipient, string memory metadata) public returns (uint256){

_tokenIds.increment();
uint256 newItemId = _tokenIds.current();
require(newItemId<=maxSupply);
tokenURIS[newItemId]=metadata;
_mint(recipient, newItemId);
_setTokenURI(newItemId, metadata);
return newItemId;
}


function totalSupply() public view override returns (uint256) {
return _tokenIds.current();
}


}