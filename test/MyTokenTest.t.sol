// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {DeployMyToken} from "../script/DeployMyToken.s.sol";
import {MyToken} from "../src/MyToken.sol";

contract myTokenTest is Test {
         MyToken public myToken;
         DeployMyToken public deploy;

         address bob = makeAddr("bob");
         address alice = makeAddr("alice");
         uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deploy = new DeployMyToken();
        myToken = deploy.run();

        vm.prank(msg.sender);
        myToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(STARTING_BALANCE, myToken.balanceOf(bob));
    }

    function testAllowancesWorks() public {
        uint256 initialAllowance = 1000;

        vm.prank(bob);
        myToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500;

        vm.prank(alice);
        myToken.transferFrom(bob, alice, transferAmount);

    assertEq(myToken.balanceOf(alice), transferAmount);

    assertEq(myToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
    }
}