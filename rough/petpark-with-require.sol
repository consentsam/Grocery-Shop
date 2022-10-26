// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract PetPark {
    //enum
    enum AnimalType {
        None,
        Fish,
        Cat,
        Dog,
        Rabbit,
        Parrot
    }

    enum Gender {
        None,
        Male,
        Female
    }

    struct UserDetails {
        address user;
        uint256 age;
        Gender gender;
        bool queriedBefore;
    }

    //Variables
    address public owner;

    //Mappings
    mapping(AnimalType => uint256) public animalCounts;
    mapping(address => AnimalType) public borrowedAnimal;
    mapping(address => UserDetails) public userDetails;

    //Events
    event Added(AnimalType _animal, uint256 _animalCount);
    event Borrowed(AnimalType _animal);
    event Returned(AnimalType _animal);

    //Constructor
    constructor() {
        owner = msg.sender;
    }

    //Modifiers
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "This function can only be called by owner of the Pet Park"
        );
        _;
    }

    //Functions

    // add
    function add(AnimalType _animal, uint256 _animalCount) external onlyOwner {
        require(
            (uint256(_animal) >= 1 && uint256(_animal) <= 5),
            "Invalid animal"
        );
        animalCounts[_animal] += _animalCount;
        emit Added(_animal, _animalCount);
    }

    //borrow
    function borrow(
        uint256 _age,
        Gender _gender,
        AnimalType _animal
    ) external {
        if (userDetails[msg.sender].queriedBefore == true) {
            require(userDetails[msg.sender].age == _age, "Invalid Age");
            require(
                userDetails[msg.sender].gender == _gender,
                "Invalid Gender"
            );
        } else {
            userDetails[msg.sender] = UserDetails(
                msg.sender,
                _age,
                _gender,
                true
            );
        }
        require(
            _age > 0,
            "You cannot borrow since you are not even a year old"
        );
        require(
            uint256(_animal) >= 1 && uint256(_animal) <= 5,
            "Invalid animal type"
        );
        require(animalCounts[_animal] > 0, "Selected animal not available");
        if (borrowedAnimal[msg.sender] == AnimalType.None) {
            if (_gender == Gender.Male) {
                if (_animal == AnimalType.Dog || _animal == AnimalType.Fish) {
                    animalCounts[_animal] -= 1;
                    borrowedAnimal[msg.sender] = _animal;
                    emit Borrowed(_animal);
                } else {
                    revert("Invalid animal for men");
                }
            } else if (_gender == Gender.Female) {
                if (_age < 40 && _animal == AnimalType.Cat) {
                    revert("Invalid animal for women under 40");
                } else {
                    animalCounts[_animal] -= 1;
                    borrowedAnimal[msg.sender] = _animal;
                    emit Borrowed(_animal);
                }
            }
        } else {
            revert("Already adopted a pet");
        }
    }

    //giveBackAnimal
    function giveBackAnimal() external {
        require(
            borrowedAnimal[msg.sender] == AnimalType.None,
            "No borrowed pets"
        );
        animalCounts[borrowedAnimal[msg.sender]] += 1;
        emit Returned(borrowedAnimal[msg.sender]);
        borrowedAnimal[msg.sender] = AnimalType.None;
    }
}
