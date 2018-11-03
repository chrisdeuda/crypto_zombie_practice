pragma solidity ^0.4.19;

// put import statement here

import "./ZombieFactory.sol";

contract ZombieFeeding is ZombieFactory {

    function feedAndMultiply (uint _zombieId, uint _targetDna) public{
        require( msg.sender == zombieToOwner[_zombieId]);

        Zombie storage myZombie = zombies[_zombieId];
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna ) /2;

        _createZombie("NoName",newDna);
    }

}
