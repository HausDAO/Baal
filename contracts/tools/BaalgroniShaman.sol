// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

import "../libraries/Base64.sol";

// import "hardhat/console.sol";

import "../interfaces/IBaal.sol";

interface IWRAPPER {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
}

interface IERC5192 {
  /// @notice Returns the locking status of an Soulbound Token
  /// @dev SBTs assigned to zero address are considered invalid, and queries
  /// about them do throw.
  /// @param tokenId The identifier for an SBT.
  function locked(uint256 tokenId) external view returns (bool);
}

contract BaalgroniShaman is ERC721, Initializable, IERC5192 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // ERC721 CONFIG
    string private _name; /*Name for ERC721 trackers*/
    string private _symbol; /*Symbol for ERC721 trackers*/

    IBaal public moloch;
    IWRAPPER public wrapper;
    BaalgroniSummoner public factory;

    uint256 public price; // ex. 200000000000000000000;
    uint256 public cap; // ex. 200;
    uint256 public lootPerUnit; // ex. 100;
    uint256 public daoCut; // ex. 3;

    string public core; // ex. "Bourbon";
    string public property; // ex. "None";
    string public atribute3; // ex. "Orange Twist";
    string public atribute2; // ex. "Up";
    string public atribute1; // ex. "Coupe";
    string public atribute0; // ex. "Sweet Vermouth";
    string public mod; // ex. "Campari";
    string public imageHash;

    mapping(uint256 => address) public bindings;

    event Bind(
        address baalgroni,
        uint256 tokedId
    );

    event Unbind(
        address baalgroni,
        uint256 tokedId
    );

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
    error OnlyLootHolderCanUnbind();

    constructor() ERC721("Template", "T") initializer {} /*Configure template to be unusable*/

    // todo: ownership
    function init(
        address _moloch,
        address _wrapper,
        uint256 _price,
        uint256 _cap,
        uint256 _lootPerUnit,
        uint256 _daoCut,
        bytes memory _initializationParams
    ) external initializer {
        moloch = IBaal(_moloch);
        wrapper = IWRAPPER(_wrapper);
        factory = BaalgroniSummoner(msg.sender);
        (
            string memory _tokenName,
            string memory _tokenSymbol,
            string memory _core,
            string memory _property,
            string memory _atribute3,
            string memory _atribute2,
            string memory _atribute1,
            string memory _atribute0,
            string memory _mod,
            string memory _imageHash
        ) = abi.decode(
                _initializationParams,
                (
                    string,
                    string,
                    string,
                    string,
                    string,
                    string,
                    string,
                    string,
                    string,
                    string
                )
            );
        _name = _tokenName;
        _symbol = _tokenSymbol;
        price = _price;
        cap = _cap;
        lootPerUnit = _lootPerUnit;
        daoCut = _daoCut;
        core = _core;
        property = _property;
        atribute3 = _atribute3;
        atribute2 = _atribute2;
        atribute1 = _atribute1;
        atribute0 = _atribute0;
        mod = _mod;
        imageHash = _imageHash;
    }

    
    function mint(address _to) public payable {
        if (msg.value < price) revert NotEnough();

        uint256 tokenId = _tokenIdCounter.current();
        if (tokenId >= cap) revert BarIsEmpty();
        // wrap
        (bool success, ) = address(wrapper).call{value: price}("");
        if (!success) revert WrapFailed();
        // send to dao
        require(wrapper.transfer(moloch.target(), price), "Transfer failed");

        if (msg.value > price) {
            // Return the extra money to the minter.
            (bool success2, ) = msg.sender.call{value: msg.value - price}("");
            if (!success2) revert TransferFailed();
        }

        _safeMint(_to, tokenId + 1);
        _tokenIdCounter.increment();

        address[] memory _receivers = new address[](2);
        _receivers[0] = address(0xdead);
        _receivers[1] = address(factory);

        uint256[] memory _amounts = new uint256[](2);
        _amounts[0] = lootPerUnit;
        _amounts[1] = daoCut;

        moloch.mintLoot(_receivers, _amounts);
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

        moloch.burnLoot(_sinkReceivers, _amounts);

        moloch.mintLoot(_receivers, _amounts);

        emit Bind(msg.sender, tokenId);
    }

    function unbind(uint256 tokenId) public {
        if (bindings[tokenId] == address(0)) revert Unbound();
        if (bindings[tokenId] != msg.sender) revert OnlyOwnerCanUnbind();
        IERC20 lootToken = IERC20(moloch.lootToken());
        if (lootToken.balanceOf(msg.sender) < lootPerUnit) revert OnlyLootHolderCanUnbind();
        bindings[tokenId] = address(0);

        address[] memory _sinkReceivers = new address[](1);
        _sinkReceivers[0] = address(0xdead);

        address[] memory _receivers = new address[](1);
        _receivers[0] = msg.sender;

        uint256[] memory _amounts = new uint256[](1);
        _amounts[0] = lootPerUnit;

        moloch.mintLoot(_sinkReceivers, _amounts);

        moloch.burnLoot(_receivers, _amounts);

        emit Unbind(msg.sender, tokenId);
    }

    function locked(uint256 _tokenId) public view override(IERC5192) returns (bool) {
        if (bindings[_tokenId] != address(0)) {
            return true;
        } else {
            return false;
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
        string memory _nftName = string(abi.encodePacked("BAALgroni: ", _name));

        bytes memory _image = abi.encodePacked(
            _baseURI(),
            imageHash,
            "/baalgroni-",
            locked(_tokenId) ? "bound" : "unbound",
            ".svg"
        );

        bytes memory _core = abi.encodePacked(
            '{"trait_type": "Core", "value": "',
            core,
            '"},',
            '{"trait_type": "atribute0", "value": "',
            atribute0,
            '"},'
        );

        bytes memory _sup = abi.encodePacked(
            '{"trait_type": "Modifiers", "value": "',
            mod,
            '"},',
            '{"trait_type": "Property", "value": "',
            property,
            '"},',
            '{"trait_type": "Atribute1", "value": "',
            atribute1,
            '"},',
            '{"trait_type": "Atribute2", "value": "',
            atribute2,
            '"},',
            '{"trait_type": "Atribute3", "value": "',
            atribute3,
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
                                '", "description": "BaalgroniShaman DAO",',
                                ' "attributes":[{"trait_type": "Locked", "value": "',
                                Strings.toHexString(bindings[_tokenId]) ,
                                '"},',
                                _core,
                                _sup,
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
        override(ERC721)
        returns (string memory)
    {
        require(
            _exists(_tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );
        return string(_constructTokenURI(_tokenId));
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
        return
            interfaceId == type(IERC5192).interfaceId ||
            super.supportsInterface(interfaceId);
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
        address baalgroni,
        address moloch,
        address wrapper,
        uint256 price,
        uint256 cap,
        uint256 lootPerUnit,
        uint256 daoCut,
        bytes initializationParams
    );

    constructor(address payable _template) {
        template = _template;
    }

    function summonBaalgroni(
        address moloch,
        address wrapper,
        uint256 price,
        uint256 cap,
        uint256 lootPerUnit,
        uint256 daoCut,
        bytes memory initializationParams
    ) public returns (address) {
        BaalgroniShaman baalgroni = BaalgroniShaman(
            payable(createClone(template))
        );

        baalgroni.init(
            moloch,
            wrapper,
            price,
            cap,
            lootPerUnit,
            daoCut,
            initializationParams
        );

        emit SummonBaalgroniComplete(
            address(baalgroni),
            moloch,
            wrapper,
            price,
            cap,
            lootPerUnit,
            daoCut,
            initializationParams
        );

        return address(baalgroni);
    }
}
