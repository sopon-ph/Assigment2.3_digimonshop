pragma solidity >=0.4.22 <0.6.0;

contract DIGIMONCharacterShop {
    
    
    struct DIGIMONCharacter{
        uint id;
        string name;
        uint256 priceTag;
        address owner;
        string imagePath;
        bool haveOwner;
    }
    
    uint C_ID = 0;
    
    uint[] collectionDigimonCharaterId;
    mapping (uint => DIGIMONCharacter) digimonCharacter;
    event PurchaseCharacterErrorLog(address indexed buyer,string reason);
    event SoldCharacter(address indexed buyer,uint id);

    
    function addCharacter(string memory name,uint256 priceTag ,string memory imagePath) public returns(uint id){
        uint Id = C_ID++;
        
        digimonCharacter[Id] = DIGIMONCharacter(Id,name, priceTag, address(0x0000000000000000000000000000000000000000), imagePath,false);
        collectionDigimonCharaterId.push(Id);
        
        return Id;
    }
    
    function sellCharacter(uint id) public payable returns(bool){
        if(msg.value != digimonCharacter[id].priceTag){
            emit PurchaseCharacterErrorLog(msg.sender,"Error, invalid value !!");
            msg.sender.transfer(msg.value);
            return false;
        }
        
        if(digimonCharacter[id].haveOwner){
            emit PurchaseCharacterErrorLog(msg.sender,"Error, this character is have owner!!");
            msg.sender.transfer(msg.value);
            return false;
        }
        
        digimonCharacter[id].owner = msg.sender;
        digimonCharacter[id].haveOwner = true;
        emit SoldCharacter(msg.sender,id);
        
        return true;
    }
    
    function getChracterById(uint Id) public view returns(uint,string memory,uint256,address,string memory,bool){
        return (digimonCharacter[Id].id,digimonCharacter[Id].name,digimonCharacter[Id].priceTag,digimonCharacter[Id].owner,digimonCharacter[Id].imagePath,digimonCharacter[Id].haveOwner);
    }
    
    function getAllCharacter() public view returns(uint[] memory){
        return collectionDigimonCharaterId;
    }
    
    function getNextValId() public view returns(uint){
        return C_ID;
    }
    
}