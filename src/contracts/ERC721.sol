// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ERC165.sol';
import './interfaces/IERC721.sol';
import './Libraries/Counters.sol';

contract ERC721 is ERC165, IERC721 {

  using SafeMath for uint256;
  using Counters for Counters.Counter;

  mapping(uint256 => address) private _tokenOwner;

  mapping(address => Counters.Counter) private _OwnedTokenCount;

  mapping(uint256 => address) private _tokenApprovals;

  constructor() {
    _registerInterface(bytes4(
      keccak256('balanceOf(bytes4)')^
      keccak256('ownerOf(bytes4)')^
      keccak256('balanceOf(bytes4)')^
      keccak256('transferFrom(bytes4)')
    ));
  }

  function balanceOf(address _owner) public override view returns (uint256) {
    require(_owner != address(0), 'owner query for non-existent token');
    return _OwnedTokenCount[_owner].current();
  }

  function ownerOf(uint256 _tokenId) public override view returns (address) {
    address owner = _tokenOwner[_tokenId];
    require(owner != address(0), 'owner query for non-existent token');
    return owner;
  }


  function _exists(uint256 tokenId) internal view returns(bool) {
    address owner = _tokenOwner[tokenId];
    return owner != address(0);
  }

  function _mint(address to, uint256 tokenId) internal virtual {
    require(to != address(0), 'ERC721: minting to the zero address');
    require(!_exists(tokenId), 'ERC721: token already minted');
    _tokenOwner[tokenId] = to;
    _OwnedTokenCount[to].increment();

    emit Transfer(address(0), to, tokenId);
  }
  function _transferFrom(address _from, address _to, uint256 _tokenId) internal {
    require(_to != address(0), 'Error - ERC721 Transfer to the zero address');
    require(ownerOf(_tokenId) == _from, 'Trying to transfer a token the address does');

    _OwnedTokenCount[_from].decrement();
    _OwnedTokenCount[_to].increment();

    _tokenOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transferFrom(address _from, address _to, uint256 _tokenId) public override {
    require(isApprovedOrOwner(msg.sender, _tokenId));
    _transferFrom(_from, _to, _tokenId);
  }

  function approve(address _to, uint256 tokenId) public {
    address owner = ownerOf(tokenId);
    require(_to != owner, 'Error - approval to current owner');
    require(msg.sender == owner, 'Current caller is not the owner of the token');
    _tokenApprovals[tokenId] = _to;
    emit Approval(owner, _to, tokenId);
  }

  function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns(bool) {
    require(_exists(tokenId), 'token does not exist');
    address owner = ownerOf(tokenId);
    return (spender == owner);
  }
}