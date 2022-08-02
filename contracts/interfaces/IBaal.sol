//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

interface IBaal {
    function lootPaused() external returns (bool);
    function sharesPaused() external returns (bool);
    function mintLoot(address[] calldata to, uint256[] calldata amount) external;
    function burnLoot(address[] calldata to, uint256[] calldata amount) external;
    function shamans(address shaman) external returns(uint256);
    function isManager(address shaman) external returns(bool);
    function target() external returns(address);
    function lootToken() external returns(address);
}
