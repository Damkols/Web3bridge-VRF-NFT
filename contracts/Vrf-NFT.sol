// SPDX-License-Identifier: MIT
pragma solidity > 0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


contract VRFNFT is ERC1155, Ownable, VRFConsumerBase {

    bytes32 internal keyHash;
    uint256 internal fee;
    mapping(uint256 => uint256[20]) public traitValues;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    uint256 private tokenIdCounter;


    constructor(address vrfCoordinator, address link, bytes32 _keyHash, uint256 _fee)
        ERC1155("ipfs://QmarWREKiu5CrgpwgRb8bbcq7zDbsMM4SQ1uhXH9XMbkDS//{id}.json")
        VRFConsumerBase(vrfCoordinator, link)
    {
        keyHash = _keyHash;
        fee = _fee;
        tokenIdCounter = 1;
    }

    function mint() external {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK to fulfill the request");
        require(LINK.transferFrom(msg.sender, address(this), fee), "LINK transfer failed");
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestIdToTokenId[requestId] = tokenIdCounter;
        tokenIdCounter++;
        _mint(msg.sender, requestIdToTokenId[requestId], 1, "");

    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 tokenId = requestIdToTokenId[requestId];
        uint256[20] memory traits;
        for (uint256 i = 0; i < 19; i++) {
            traits[i] = (randomness % 101); 
            randomness = randomness / 101;
        }
        traitValues[tokenId] = traits;
        _mint(msg.sender, tokenId, 1, "");

    }

}
