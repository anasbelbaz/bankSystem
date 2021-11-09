// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Bank is Ownable {
    // address admin;
    uint256 dateMinimum;
    uint256 depotID;

    mapping(uint256 => uint256) depots;

    event nouvelleEpargne(uint256 dateMinimum);
    event argentDepose(uint256 date, uint256 value);

    //constructor(){
    //    admin=msg.sender;
    //}

    receive() external payable {
        if (address(this).balance == 0) {
            dateMinimum = block.timestamp + 12 weeks;
            emit nouvelleEpargne(dateMinimum);
        }
        depotID += 1;
        depots[depotID] = msg.value;
        emit argentDepose(block.timestamp, msg.value);
    }

    function sendEth() public payable {
        require(msg.value > 2, "Not enough Wei");
        if (address(this).balance == 0) {
            dateMinimum = block.timestamp + 12 weeks;
            emit nouvelleEpargne(dateMinimum);
        }
        depotID += 1;
        depots[depotID] = msg.value;
        emit argentDepose(block.timestamp, msg.value);
    }

    function withdrawEth() public onlyOwner {
        // require(msg.sender==admin, "tu n'es pas l'admin de ce contrat");
        require(block.timestamp >= dateMinimum, "Did not wait");
        payable(msg.sender).transfer(address(this).balance);
    }

    function getBalance() public view onlyOwner returns (uint256) {
        return address(this).balance;
    }
}
