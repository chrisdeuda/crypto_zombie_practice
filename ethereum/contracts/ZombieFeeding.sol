pragma solidity ^0.4.19;

// put import statement here

import "./ZombieFactory.sol";
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
        );

}

contract ZombieFeeding is ZombieFactory {
    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // Initialize kittyContract here using `ckAddress` from above
    KittyInterface kittyContract;
    
    function setKittyContractAddress(address _address) external onlyOwner{
      kittyContract = KittyInterface(_address);
    }

    function _triggerCooldown(Zombie storage _zombie) internal {
        _zombie.readyTime = uint32(now + cooldownTime);
    }

    function _isReady(Zombie storage _zombie) internal view returns (bool){
        return (_zombie.readyTime <= now);
    }

    function feedAndMultiply (uint _zombieId, uint _targetDna) public {
        require( msg.sender == zombieToOwner[_zombieId]);

        Zombie storage myZombie = zombies[_zombieId];
        require( _isReady(myZombie));
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna ) /2;

        // Explanation: Assume newDna is 334455. 
        //Then newDna % 100 is 55, so newDna - newDna % 100 is 334400.
        // Finally add 99 to get 334499.
        if ( keccak256(_species) == keccak256("kitty") ) {
            newDna = newDna - newDna % 100 + 99;
        }

        _createZombie("NoName",newDna);
        _triggerCooldown(myZombie);
    }

    function feedOnKitty( uint _zombieId, uint _kittyId) public {
        uint kittyDna ;
        (,,,,,,,,,kittyDna ) = kittyContract.getKitty(_kittyId);
        feedAndMultiply(_zombieId, kittyDna, "kitty");
    }

}
