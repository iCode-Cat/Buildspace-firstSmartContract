// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    struct waveStorage {
        address waver;
        uint256 totalWave;
    }

    struct Wave {
        address waver; // The address of the user who waved.
        string message; // The message the user sent.
        uint256 timestamp; // The timestamp when the user waved.
    }

    uint256 totalWaves;
    mapping(address => bool) private checkWaved;
    mapping(address => waveStorage) public waveStorageMapping;
    Wave[] waves;

    mapping(address => uint256) public lastWavedAt;

    // waveStorage[] private allWaves;

    /*
     * A little magic, Google what events are in Solidity!
     */
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");
        /*
         * Set the initial seed
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        /*
         * We need to make sure the current timestamp is at least 15-minutes bigger than the last timestamp we stored
         */
        require(
            lastWavedAt[msg.sender] + 15 minutes < block.timestamp,
            "Wait 15m"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;

        if (!checkWaved[msg.sender]) {
            checkWaved[msg.sender] = true;
            waveStorageMapping[msg.sender] = waveStorage(msg.sender, 1);
        } else {
            waveStorageMapping[msg.sender].totalWave += 1;
        }
        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * Generate a new seed for the next user that sends a wave
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;
        console.log("Random # generated: %d", seed);
        /*
         * Give a 50% chance that the user wins the prize.
         */
        if (seed < 50) {
            console.log("%s won!", msg.sender);
            console.log("%s has waved!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}((""));
            require(success, "Failed to withdraw money from contract.");
        }
        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function checkUserWaved() public view returns (bool) {
        if (checkWaved[msg.sender]) {
            return true;
        } else {
            return false;
        }
    }

    // function iterateUserWave() private {
    //   for (uint i = 0; i < allWaves.length;i++) {
    //     if(allWaves[i].waver == msg.sender) {
    //       allWaves[i].totalWave += 1;
    //       console.log(allWaves[i].waver,allWaves[i].totalWave);
    //     }
    //   }
    // }

    // function getTotalWaveOfUser(address user) public view returns(uint256) {
    //    for (uint i = 0; i < allWaves.length;i++) {
    //   if(allWaves[i].waver == msg.sender) {
    //      if( allWaves[i].waver == user) {
    //        return allWaves[i].totalWave;
    //      }
    //     }
    //    }
    //     return 0;
    // }
}
