// SPDX-License-Identifier: GPL-3.0
// Amended by HashLips
/**
    !Disclaimer!
    These contracts have been used to create tutorials,
    and was created for the purpose to teach people
    how to create smart contracts on the blockchain.
    please review this code on your own before using any of
    the following code for production.
    HashLips will not be liable in any way if for the use 
    of the code. That being said, the code has been tested 
    to the best of the developers' knowledge to work as intended.
*/
pragma solidity >=0.7.0 <0.9.0;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract NFT_Rocket_Elevators_Full_Flat is ERC721Enumerable, Ownable {
  using Strings for uint256;
  string public baseURI;
  string public baseExtension = ".json";
  string public notRevealedUri;
  uint256 public cost = 0.01 ether;
  uint256 public discountCost = 0.005 ether;
  uint256 public maxSupply = 1000;
  uint256 public maxMintAmount = 10;
  uint256 public nftPerAddressLimit = 3;
  uint256 public NFTRocketCost = 100000;
  uint256 public discountNFTRocketCost = 50000;
  bool public paused = false;
  bool public revealed = false;
  string public rocketTokenAddress = "0x3b8F02Aa259f1c55fC2afaFF9cC3695074Ff80EB";
  // Unix Times
  uint public saleStart = 1640368800; //Date and time (GMT): Friday, December 24, 2021 18:00:00 (1 pm EST)
  uint public saleEnd = 1640908799; //Date and time (GMT): Thursday, December 30, 2021 11:59:59 PM
  // uint public revealedStart = 1640613600; //Date and time (GMT): Monday, December 27, 2021 14:00:00 (9 am EST)
  // Client
  bool public onlyWhitelisted = true;
  address[] public whitelistedAddresses;
  error salesCompleted();
  event PaymentDone(
      address payer,
      uint amount,
      uint date
  );
  mapping(address => uint256) public addressMintedBalance;
  constructor(
    string memory _name,
    string memory _symbol
  ) ERC721(_name, _symbol) {
    setBaseURI("ipfs://QmZP6HaTaTcXpbs4FAvp9TiR5k2Hq1vuHca2GVUBfHr5KN/");
    setNotRevealedURI("ipfs://Qmchw8tWq7ewMgdXygRr39DZB3Yf53UiFEEhLhJMb9NmP6/hidden.json");
    // addresses given
    // clients
    whitelistedAddresses.push(0x49C99dB83eA1cDa354b718A4Be90f4B1C3Dc94A4);
    whitelistedAddresses.push(0xd1679bB3543e8aD195FF9f3Ac3436039bA389237);
    // Domin
    whitelistedAddresses.push(0xde4F53f2735467330B8b884abdd0d131aA98ef82);
    // Long
    whitelistedAddresses.push(0xb28C0431f0D4EAd93167c18bc25F7959fd56Dd2A);
    // Jasmine
    whitelistedAddresses.push(0xb28C0431f0D4EAd93167c18bc25F7959fd56Dd2A);
    // Carl
    whitelistedAddresses.push(0x60911dC5af0DF086cd685d9e2d35744e266184a7);
    whitelistedAddresses.push(0x5e0ACa5Ca440a91dA8D51f893Da92E332A9A5fd5);
    
  }
  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }
  // public
  function mint(uint256 _mintAmount) public payable {
    require(!paused, "the contract is paused");
    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
    if (msg.sender != owner()) {
      if (block.timestamp <= saleStart) {     
        require(isWhitelisted(msg.sender), "user is not whitelisted");
        uint256 ownerMintedCount = addressMintedBalance[msg.sender];
        require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
        require (msg.value >= discountCost * _mintAmount, "insufficient funds");
      }
      // Correspond to official sale
      else if (block.timestamp <= saleEnd) {
      require (msg.value >= cost * _mintAmount, "insufficient funds");
      } else {
        revert salesCompleted();
      }
    }
    for (uint256 i = 1; i <= _mintAmount; i++) {
      addressMintedBalance[msg.sender]++;
      _safeMint(msg.sender, supply + i);
    }
  } // end function 
  
  function isWhitelisted(address _user) public view returns (bool) {
    for (uint i = 0; i < whitelistedAddresses.length; i++) {
      if (whitelistedAddresses[i] == _user) {
          return true;
      }
    }
    return false;
  } // end function
  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }
  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    if(revealed == false) {
        return notRevealedUri;
    }
    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }
  //only owner
  function reveal() public onlyOwner {
      revealed = true;
  }
  
  function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
    nftPerAddressLimit = _limit;
  }
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }
  function setDiscountCost(uint256 _newDiscountCost) public onlyOwner {
    discountCost = _newDiscountCost;
  }
  function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
    maxMintAmount = _newmaxMintAmount;
  }
  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }
  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
    notRevealedUri = _notRevealedURI;
  }
  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
  
  function setOnlyWhitelisted(bool _state) public onlyOwner {
    onlyWhitelisted = _state;
  }
  
  function whitelistUsers(address[] calldata _users) public onlyOwner {
    delete whitelistedAddresses;
    whitelistedAddresses = _users;
  }
  function whitelistAddress(address add) public onlyOwner {
    whitelistedAddresses.push(add);
  }
 
  function withdraw() public payable onlyOwner {
    // This will pay HashLips 5% of the initial sale.
    // You can remove this if you want, or keep it in to support HashLips and his channel.
    // =============================================================================
    // (bool hs, ) = payable(0x943590A42C27D08e3744202c4Ae5eD55c2dE240D).call{value: address(this).balance * 5 / 100}("");
    // require(hs);
    // =============================================================================
    
    // This will payout the owner 95% of the contract balance.
    // Do not remove this otherwise you will not be able to withdraw the funds.
    // =============================================================================
    (bool os, ) = payable(owner()).call{value: address(this).balance}("");
    require(os);
    // =============================================================================
  }
  function mintWithRocketToken(uint _mintAmount) public {
      uint256 supply = totalSupply();
      IERC20 rocketToken = IERC20(0x3b8F02Aa259f1c55fC2afaFF9cC3695074Ff80EB);
      uint accountBalance = rocketToken.balanceOf(msg.sender);
      
      
      uint256 ownerMintedCount = addressMintedBalance[msg.sender];
      require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
      if(msg.sender != owner()){
          if(block.timestamp <= saleStart){
              require(isWhitelisted(msg.sender), "address is not whitelisted");
              require(accountBalance >= discountNFTRocketCost * _mintAmount);
              rocketToken.transferFrom(msg.sender, address(this), discountNFTRocketCost * _mintAmount);
          } else if (block.timestamp <= saleEnd){
              require(accountBalance >= NFTRocketCost * _mintAmount, "insufficient funds");
              rocketToken.transferFrom(msg.sender, address(this), NFTRocketCost * _mintAmount);
          }else{
              revert salesCompleted();
          }
      }
      for (uint256 i = 1; i <= _mintAmount; i++){
          addressMintedBalance[msg.sender]++;
          _safeMint(msg.sender, supply+i);
      }
      emit PaymentDone(msg.sender, _mintAmount, block.timestamp);
  }
}