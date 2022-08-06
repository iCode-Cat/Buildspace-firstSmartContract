// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    struct waveStorage {
        address waver;
        uint256 totalWave;
    }

    uint256 totalWaves;
    mapping(address => bool) private checkWaved;
    mapping(address => waveStorage) public waveStorageMapping;

    // waveStorage[] private allWaves;

    constructor() {
        console.log("Yo yo, I am a contract and I am smart");
    }

    function wave() public {
        totalWaves += 1;

        if (!checkWaved[msg.sender]) {
            checkWaved[msg.sender] = true;
            waveStorageMapping[msg.sender] = waveStorage(msg.sender, 1);
        } else {
            waveStorageMapping[msg.sender].totalWave += 1;
        }
        console.log("%s has waved!", msg.sender);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
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
