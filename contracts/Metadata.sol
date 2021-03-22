pragma solidity ^0.4.24;

import "./contracts/token/ERC721/ERC721Metadata.sol";
import "./Ownable.sol";
 
contract Metadata is ERC721Metadata, Ownable {
    
    uint256 public lastTokenIndex;
    
    constructor(string memory name, string memory symbol) public ERC721Metadata(name, symbol){
    }
    
    function mint(address to) public onlyOwner returns(uint256) {
        _mint(to, lastTokenIndex + 1);
        lastTokenIndex = lastTokenIndex + 1;
        return lastTokenIndex;
    }
    
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public onlyOwner {
        _setTokenURI(tokenId,_tokenURI);
    }
  
}