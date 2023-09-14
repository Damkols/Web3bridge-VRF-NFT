// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";


//Still working on this
contract MyNFT is ERC721Enumerable, VRFConsumerBase {
    bytes32 internal keyHash;
    uint256 internal fee;

    mapping(bytes32 => uint256) public requestToTokenId;
    mapping(uint256 => uint256) public energyTraits;
    mapping(uint256 => uint256) public speedTraits;
    mapping(uint256 => uint256) public flairTraits;
    mapping(uint256 => uint256) public swerveTraits;
    mapping(uint256 => uint256) public finesseTraits;
    mapping(uint256 => uint256) public techniqueTraits;

    constructor(
        address _vrfCoordinator,
        address _linkToken,
        bytes32 _keyHash,
        uint256 _fee
    )
        ERC721("MyNFT", "MNFT")
        VRFConsumerBase(_vrfCoordinator, _linkToken)
    {
        keyHash = _keyHash;
        fee = _fee;
    }

    function mintNFT() external {
        require(totalSupply() < 100, "Maximum supply reached");
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK tokens");

        bytes32 requestId = requestRandomness(keyHash, fee);

        uint256 tokenId = totalSupply() + 1;
        requestToTokenId[requestId] = tokenId;

    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        uint256 tokenId = requestToTokenId[requestId];
        require(tokenId > 0, "Invalid requestId");

        uint256 energy = randomness % 101;
        uint256 speed = randomness % 101; 
        uint256 flair = randomness % 101; 
        uint256 swerve = randomness % 101; 
        uint256 finesse = randomness % 101;
        uint256 technique = randomness % 101;

        _mint(msg.sender, tokenId);
        energyTraits[tokenId] = energy;
        speedTraits[tokenId] = speed;
        speedTraits[tokenId] = speed;
        flairTraits[tokenId] = flair;
        swerveTraits[tokenId] = swerve;
        finesseTraits[tokenId] = finesse;
        techniqueTraits[tokenId] = technique;
    }
}
