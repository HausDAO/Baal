// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

interface IERC20 {
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);
    function approve(address spender, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

interface IBAAL {
    function mintLoot(address[] calldata to, uint256[] calldata amount) external;
    function shamans(address shaman) external returns(uint256);
    function isManager(address shaman) external returns(bool);
    function target() external returns(address);
}

abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and make it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}

abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

contract OnboarderShaman is ReentrancyGuard {
    event YeetReceived(
        address indexed contributorAddress,
        uint256 amount,
        address baal,
        uint256 lootToGive,
        uint256 lootToPlatform
    );
    mapping(address => uint256) public deposits;
    uint256 public maxTarget;
    uint256 public raiseEndTime;
    uint256 public raiseStartTime;
    uint256 public maxUnitsPerAddr;
    uint256 public pricePerUnit;
    uint256 public lootPerUnit;
    bool public onlyERC20;
    bool public initialized;

    uint256 public platformFee;

    uint256 public balance;
    IBAAL public baal;
    IERC20 public token;

    OnboarderShamanSummoner factory;

    function init(
        address _baal,
        address payable _token, // use wraper for native yeets
        uint256 _maxTarget, // max raise target
        uint256 _raiseEndTime,
        uint256 _raiseStartTime,
        uint256 _maxUnits, // per individual
        uint256 _pricePerUnit,
        bool _onlyERC20
    ) public {
        require(!initialized, "already initialized");
        initialized = true;
        baal = IBAAL(_baal);
        token = IERC20(_token);
        maxTarget = _maxTarget;
        raiseEndTime = _raiseEndTime;
        raiseStartTime = _raiseStartTime;
        maxUnitsPerAddr = _maxUnits;
        pricePerUnit = _pricePerUnit;
        onlyERC20 = _onlyERC20;
        factory = OnboarderShamanSummoner(msg.sender);
    }

    function initTemplate() public {
        initialized = true;
    }

    function onboarder20(uint256 _value) public nonReentrant {
        require(address(baal) != address(0), "!init");
        // require(msg.value >= pricePerUnit, "< minimum");
        require(balance < maxTarget, "Max Target reached"); // balance plus newvalue
        require(block.timestamp < raiseEndTime, "Time is up");
        require(block.timestamp > raiseStartTime, "Not Started");
        require(baal.isManager(address(this)), "Shaman not whitelisted");

        require(_value % pricePerUnit == 0, "!valid amount"); // require value as multiple of units

        uint256 numUnits = _value / pricePerUnit;

        // if some one yeets over max should we give them the max and return leftover.
        require(
            deposits[msg.sender] + _value <= maxUnitsPerAddr * pricePerUnit,
            "Can not deposit more than max"
        );

        // send to dao
        require(token.transferFrom(msg.sender, baal.target(), _value), "Transfer failed");


        // TODO: check
        deposits[msg.sender] = deposits[msg.sender] + _value;

        balance = balance + _value;

        uint256 lootToGive = (numUnits * factory.lootPerUnit());
        uint256 lootToPlatform = (numUnits * factory.platformFee());

        address[] memory recs = new address[](1);
        recs[0] = msg.sender;
        uint256[] memory gives = new uint256[](1);
        gives[0] = lootToGive;

        baal.mintLoot(recs, gives);
        if (lootToPlatform > 0) {
            address[] memory platRecs = new address[](1);
            platRecs[0] = address(factory);
            uint256[] memory platGives = new uint256[](1);
            platGives[0] = lootToPlatform;
            baal.mintLoot(platRecs, platGives);
        }

        // amount of loot? fees?
        emit YeetReceived(
            msg.sender,
            _value,
            address(baal),
            lootToGive,
            lootToPlatform
        );
    }

    function onboarder() public payable nonReentrant {
        require(!onlyERC20, "!native");
        require(address(baal) != address(0), "!init");
        require(msg.value >= pricePerUnit, "< minimum");
        require(balance < maxTarget, "Max Target reached"); // balance plus newvalue
        require(block.timestamp < raiseEndTime, "Time is up");
        require(block.timestamp > raiseStartTime, "Not Started");
        require(baal.isManager(address(this)), "Shaman not whitelisted");


        uint256 numUnits = msg.value / pricePerUnit; // floor units
        uint256 newValue = numUnits * pricePerUnit;

        // if some one yeets over max should we give them the max and return leftover.
        require(
            deposits[msg.sender] + newValue <= maxUnitsPerAddr * pricePerUnit,
            "Can not deposit more than max"
        );

        // wrap
        (bool success, ) = address(token).call{value: newValue}("");
        require(success, "Wrap failed");
        // send to dao
        require(token.transfer(baal.target(), newValue), "Transfer failed");

        if (msg.value > newValue) {
            // Return the extra money to the minter.
            (bool success2, ) = msg.sender.call{value: msg.value - newValue}(
                ""
            );
            require(success2, "Transfer failed");
        }
        // TODO: check
        deposits[msg.sender] = deposits[msg.sender] + newValue;

        balance = balance + newValue;

        uint256 lootToGive = (numUnits * factory.lootPerUnit());
        uint256 lootToPlatform = (numUnits * factory.platformFee());

        address[] memory recs = new address[](1);
        recs[0] = msg.sender;
        uint256[] memory gives = new uint256[](1);
        gives[0] = lootToGive;

        baal.mintLoot(recs, gives);
        if (lootToPlatform > 0) {
            address[] memory platRecs = new address[](1);
            platRecs[0] = address(factory);
            uint256[] memory platGives = new uint256[](1);
            platGives[0] = lootToPlatform;
            baal.mintLoot(platRecs, platGives);
        }

        // amount of loot? fees?
        emit YeetReceived(
            msg.sender,
            newValue,
            address(baal),
            lootToGive,
            lootToPlatform
        );
    }

    receive() external payable {
        onboarder();
    }

    function goalReached() public view returns (bool) {
        return balance >= maxTarget;
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

contract OnboarderShamanSummoner is CloneFactory, Ownable {
    address payable public template;
    uint256 public yeetIdx = 0;

    uint256 public platformFee = 3; // fee of 3.09%
    uint256 public lootPerUnit = 100;

    event PlatformFeeUpdate(uint256 platformFee, uint256 lootPerUnit);

    event SummonOnbShamanoarderComplete(
        address indexed baal,
        address onboarder,
        address wrapper,
        uint256 maxTarget,
        uint256 raiseEndTime,
        uint256 raiseStartTime,
        uint256 maxUnits,
        uint256 pricePerUnit,
        string details,
        bool _onlyERC20
    );
            // bool _onlyERC20

    constructor(address payable _template) {
        template = _template;
        OnboarderShaman _onboarder = OnboarderShaman(_template);
        _onboarder.initTemplate();
    }

    function summonOnboarder(
        address _baal,
        address payable _token,
        uint256 _maxTarget,
        uint256 _raiseEndTime,
        uint256 _raiseStartTime,
        uint256 _maxUnits,
        uint256 _pricePerUnit,
        string calldata _details,
        bool _onlyERC20
    ) public returns (address) {
        OnboarderShaman onboarder = OnboarderShaman(payable(createClone(template)));

        onboarder.init(
            _baal,
            _token,
            _maxTarget,
            _raiseEndTime,
            _raiseStartTime,
            _maxUnits,
            _pricePerUnit,
            _onlyERC20
        );


        emit SummonOnbShamanoarderComplete(
            _baal,
            address(onboarder),
            _token,
            _maxTarget,
            _raiseEndTime,
            _raiseStartTime,
            _maxUnits,
            _pricePerUnit,
            _details,
            _onlyERC20
        );

        return address(onboarder);
    }

    // owner only functions
    function setConfig(uint256 _platformFee, uint256 _lootPerUnit)
        public
        onlyOwner
    {
        require(_lootPerUnit > 0, "Can not be 0");
        platformFee = _platformFee;
        lootPerUnit = _lootPerUnit;
        emit PlatformFeeUpdate(platformFee, lootPerUnit);
    }
}
