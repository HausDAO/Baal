// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "../libraries/Base64.sol";

// import "hardhat/console.sol";

import "../interfaces/IBaal.sol";

interface IWRAPPER {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

contract Baalgroni is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    IBaal public moloch;
    IWRAPPER public wrapper;
    uint256 public price = 200000000000000000000;
    uint256 public cap = 200;
    uint256 public lootPerUnit = 100;
    uint256 public daoCut = 3;

    string public name = "Boulevardier";
    string public core = "Bourbon";
    string public prop = "None";
    string public garnishe = "Orange Twist";
    string public ice = "Up";
    string public glassware = "Coupe";
    string public mod = "Campari";
    string public lengthener = "Sweet Vermouth";

    mapping(uint256 => address) public bindings;


    error InvalidIndex();
    error Bound();
    error Unbound();
    error OnlyOwnerCanUnbind();
    error OnlyOwnerCanBind();
    error NotEnough();
    error InvalidOrder();
    error BarIsEmpty();
    error WrapFailed();
    error TransferFailed();

    constructor(address _moloch, address _wrapper) ERC721("Daogroni", "GRONI") {
        moloch = IBaal(_moloch);
        wrapper = IWRAPPER(_wrapper);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://daohaus.mypinata.cloud/ipfs/";
    }

    // orderId is the order of the drink type in names
    function orderDrink(address _to) public payable {
        if (msg.value < price) revert NotEnough();

        uint256 tokenId = _tokenIdCounter.current();
        if(tokenId >= cap) revert BarIsEmpty();
        // wrap
        (bool success, ) = address(wrapper).call{value: price}("");
        if(!success) revert WrapFailed();
        // send to dao
        require(wrapper.transfer(moloch.target(), price), "Transfer failed");

        if (msg.value > price) {
            // Return the extra money to the minter.
            (bool success2, ) = msg.sender.call{value: msg.value - price}("");
            if(!success2) revert TransferFailed();
        }

        
        _safeMint(_to, tokenId + 1);
        _tokenIdCounter.increment();

        address[] memory _receivers = new address[](2);
        _receivers[0] = address(0xdead);
        _receivers[1] = address(owner());

        uint256[] memory _amounts = new uint256[](2);
        _amounts[0] = lootPerUnit;
        _amounts[1] = daoCut;

        moloch.mintLoot(
            _receivers,
            _amounts
        );

    }

    function bind(uint256 tokenId) public {
        if (ownerOf(tokenId) != msg.sender) revert OnlyOwnerCanBind();
        if (bindings[tokenId] != address(0)) revert Bound();
        bindings[tokenId] = msg.sender;

        address[] memory _sinkReceivers = new address[](1);
        _sinkReceivers[0] = address(0xdead);

        address[] memory _receivers = new address[](1);
        _receivers[0] = msg.sender;

        uint256[] memory _amounts = new uint256[](1);
        _amounts[0] = lootPerUnit;

         moloch.burnLoot(
            _sinkReceivers,
            _amounts
        );

        moloch.mintLoot(
            _receivers,
            _amounts
        );

    }

    function unbind(uint256 tokenId) public {
        if (bindings[tokenId] == address(0)) revert Unbound();
        if (bindings[tokenId] != msg.sender) revert OnlyOwnerCanUnbind();
        bindings[tokenId] = address(0);

        address[] memory _sinkReceivers = new address[](1);
        _sinkReceivers[0] = address(0xdead);

        address[] memory _receivers = new address[](1);
        _receivers[0] = msg.sender;

        uint256[] memory _amounts = new uint256[](1);
        _amounts[0] = lootPerUnit;

         moloch.mintLoot(
            _sinkReceivers,
            _amounts
        );

        moloch.burnLoot(
            _receivers,
            _amounts
        );

    }

    function _drinkState(uint256 _tokenId)
        internal
        view
        returns (string memory)
    {
        if (bindings[_tokenId] != address(0)) {
            return string("-empty");
        } else {
            return string("");
        }
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721) {
        super._beforeTokenTransfer(from, to, tokenId);
        if (bindings[tokenId] != address(0)) revert Bound();
    }

    /**  Constructs the tokenURI, separated out from the public function as its a big function.
     * Generates the json data URI and svg data URI that ends up sent when someone requests the tokenURI
     * svg has a image tag that can be updated by the owner (dao)
     * param: _tokenId the tokenId
     */
    function _constructTokenURI(uint256 _tokenId)
        internal
        view
        returns (string memory)
    {
        string memory _nftName = string(
            abi.encodePacked("BAALgroni: ", name)
        );
        // console.log("_nftName", _nftName);

        bytes memory _image = abi.encodePacked(
            _baseURI(),
            "QmaCBoYHdQ9u7zwp1Sxxaig1yfuocTLzk9iAr1m1ahukBK",
            "/baalgroni-",
            _drinkState(_tokenId),
            ".svg"
        );

        bytes memory _ingredients = abi.encodePacked(
            '{"trait_type": "Core", "value": "',
            core,
            '"},',
            '{"trait_type": "Lengtheners", "value": "',
            lengthener,
            '"},',
            '{"trait_type": "Modifiers", "value": "'
        );

        bytes memory _stuff = abi.encodePacked(
            mod,
            '"},',
            '{"trait_type": "Props", "value": "',
            prop,
            '"},',
            '{"trait_type": "Garnishes", "value": "',
            garnishe,
            '"},',
            '{"trait_type": "Ice", "value": "',
            ice,
            '"},',
            '{"trait_type": "Glassware", "value": "',
            glassware,
            '"}'
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                _nftName,
                                '", "image":"',
                                _image,
                                '", "description": "Drink Responsibly",',
                                '"redeemed": "',
                                Strings.toString(bindings[_tokenId]),
                                '", "attributes":[{"trait_type": "Drank", "value": "',
                                Strings.toString(bindings[_tokenId]),
                                '"},',
                                _ingredients,
                                _stuff,
                                "]}"
                            )
                        )
                    )
                )
            );
    }

    /* Returns the json data associated with this token ID
     * param _tokenId the token ID
     */
    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(_constructTokenURI(_tokenId));
    }
}
contract CloneFactory {
    // implementation of eip-1167 - see https://eips.ethereum.org/EIPS/eip-1167
    function createClone(address target) internal returns (address result) {
        bytes20 targetBytes = bytes20(target);
        assembly {
            let clone := mload(0x40)
            mstore(
                clone,
                0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000
            )
            mstore(add(clone, 0x14), targetBytes)
            mstore(
                add(clone, 0x28),
                0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000
            )
            result := create(0, clone, 0x37)
        }
    }
}

contract BaalgroniSummoner is CloneFactory, Ownable {
    address payable public template;

    event SummonBaalgroniComplete(
        address indexed baal,
        address onboarder,
        address wrapper,
        uint256 pricePerUnit,
        string details,
        bool _onlyERC20
    );

    constructor(address payable _template) {
        template = _template;
        Baalgroni _onboarder = Baalgroni(_template);
        _onboarder.initTemplate();
    }

    function summonBaalgroni(
        address _baal,
        address payable _token,
        uint256 _pricePerUnit,
        string calldata _details,
        bool _onlyERC20,
        uint256 _platformFee, 
        uint256 _lootPerUnit
    ) public returns (address) {
        Baalgroni balgroni = Baalgroni(payable(createClone(template)));

        balgroni.init(
            _baal,
            _token,
            _pricePerUnit,
            _onlyERC20,
            _platformFee,
            _lootPerUnit
        );


        emit SummonBaalgroniComplete(
            _baal,
            address(baalgroni),
            _token,
            _pricePerUnit,
            _details,
            _onlyERC20
        );

        return address(baalgroni);
    }
