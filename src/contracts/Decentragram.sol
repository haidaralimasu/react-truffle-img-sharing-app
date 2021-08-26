pragma solidity ^0.5.0;

contract Decentragram {
	string public name = "Decentragram";

	//Store Images
	uint public imageCount = 0;
	mapping(uint => Image) public images;

	//Image Datatype
	struct Image {
		uint id;
		string hash;
		string description;
		uint tipAmount;
		address payable author;
	}

	//Event (Notification)
	event ImageCreated (
		uint id,
		string hash,
		string description,
		uint tipAmount,
		address payable author
	);

	event ImageTipped (
		uint id,
		string hash,
		string description,
		uint tipAmount,
		address payable author
	);
	
	//Create Images
	function uploadImage(string memory _imgHash, string memory _description) public{
		//Image Hash Exists
		require(bytes(_imgHash).length > 0);

		//Address is Correct
		require(msg.sender != address(0x0));

		//Image Description Exist
		require(bytes(_description).length > 0);

		//Increment image id
		imageCount ++;

		//Add Image to contract
		images[imageCount] = Image(imageCount, _imgHash, _description, 0, msg.sender);

		//Notification
		emit ImageCreated(imageCount, _imgHash, _description, 0, msg.sender);
	}

	//Tip Images
	function tipImageOwner(uint _id) public payable {
		require(_id > 0 && _id <= imageCount);

		//Fecthing the image
		Image memory _image = images[_id];

		//Fecth author
		address payable _author = _image.author;

		address(_author).transfer(msg.value);

		_image.tipAmount = _image.tipAmount = msg.value;

		images[_id] = _image;

		emit ImageCreated(_id, _image.hash, _image.description, _image.tipAmount, _author);
	}
}
