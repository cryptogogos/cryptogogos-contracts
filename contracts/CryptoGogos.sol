// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CryptoGogos is ERC721, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds; //Counter is a struct in the Counters library
    using SafeMath for uint256;

    uint256 private constant maxSupply = 7777;

    uint256 private maxSalePrice = 1 ether;

    constructor(string memory _baseURI) public ERC721("GOGOS", "GOG") {
        _setBaseURI(_baseURI);
    }

    /**
     * @dev Gets current gogo Pack Price
     */
    function getNFTPackPrice() public view returns (uint256) {
        uint256 currentSupply = totalSupply();

        if (currentSupply >= 7150) {
            return maxSalePrice.mul(3 * 83333333).div(100000000);
        } else if (currentSupply >= 3150) {
            return 0.55 ether;
        } else if (currentSupply >= 850) {
            return 0.4 ether;
        } else {
            return 0;
        }
    }

    /**
     * @dev Gets current gogo Price
     */
    function getNFTPrice() public view returns (uint256) {
        uint256 currentSupply = totalSupply();

        if (currentSupply >= 7150) {
            return maxSalePrice;
        } else if (currentSupply >= 3150) {
            return 0.2 ether;
        } else if (currentSupply >= 850) {
            return 0.15 ether;
        } else if (currentSupply >= 150) {
            return 0.1 ether;
        } else if (currentSupply >= 75) {
            return 0.07 ether;
        } else {
            return 0.05 ether;
        }
    }

    /**
     * @dev Gets current gogo Price
     */
    function updateMaxPrice(uint256 _price) public onlyOwner {
        maxSalePrice = _price;
    }

    /**
     * @dev Creates a new token for `to`. Its token ID will be automatically
     * assigned (and available on the emitted {IERC721-Transfer} event), and the token
     * URI autogenerated based on the base URI passed at construction.
     *
     *
     * Requirements:
     *
     * - the caller must have the `MINTER_ROLE`.
     */
    function mintByAdmin(address to) public onlyOwner {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= maxSupply);
        _mint(to, newItemId);
    }

    /*
     *  _tokenURI is link to json
     */
    function mint() public payable returns (uint256) {
        require(getNFTPrice() == msg.value, "Ether value sent is not correct");
        uint256 currentSupply = totalSupply();
        if (totalSupply() <= 150 && balanceOf(msg.sender) >= 2) revert();
        if (totalSupply() <= 300 && balanceOf(msg.sender) >= 4) revert();
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        require(newItemId <= maxSupply);
        _mint(msg.sender, newItemId);
        return newItemId;
    }

    /*
     *  _tokenURIs is a array of links to json
     */
    function mintPack() public payable returns (uint256) {
        require(totalSupply() >= 850, "Pack is not available now");
        require(
            getNFTPackPrice() == msg.value,
            "Ether value sent is not correct"
        );

        uint256 newItemId;
        for (uint256 i = 0; i < 3; i++) {
            _tokenIds.increment();
            newItemId = _tokenIds.current();
            require(newItemId <= maxSupply);
            _mint(msg.sender, newItemId);
        }
        return newItemId;
    }

    function updateBaseURI(string memory _baseURI) public onlyOwner {
        _setBaseURI(_baseURI);
    }

    /**
     * @dev Withdraw ether from this contract (Callable by owner)
     */
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        msg.sender.transfer(balance);
    }
}
