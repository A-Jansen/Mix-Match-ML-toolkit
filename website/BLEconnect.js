const serviceUuid = "e098a7b1-9074-4e8f-bb89-2a8e84a1a271";
let isConnected = false;
var connectButton;
var disconnectButton;
var identifier;

var incomingValues = [255, 255, 255];
var emptyArray = [255, 255, 255];
var tags = [255, 255, 255];
var loc = [0, 0, 0];
var tagsPresent = 0;

var dataTokens = [242, 02];
var abilityTokens = [140, 24];
var supTokens = [140];
var unsupTokens = [24];
var reinTokens = [];
var labelTokens = [224];

var tag1;
var tag2;
var tag3;
var tagRemoved = false;
var labelPresent = false;

function setup() {
  // Create a p5ble class
  myBLE = new p5ble();

  connectButton = select('#connectBLE');
  connectButton.mousePressed(connectToBle);

}

function connectToBle() {
  // Connect to a device by passing the service UUID
  myBLE.connect(serviceUuid, gotCharacteristics);
}

function disconnectToBle() {
  // Disonnect to the device
  myBLE.disconnect();
  // Check if myBLE is connected
  isConnected = myBLE.isConnected();
}

function onDisconnected() {
  console.log('Device got disconnected.');
  isConnected = false;
}

// A function that will be called once got characteristics
function gotCharacteristics(error, characteristics) {
  if (error) console.log('error: ', error);
  console.log('characteristics: ', characteristics);
  myCharacteristic = characteristics[0];
  // Start notifications on the first characteristic by passing the characteristic
  // And a callback function to handle notifications
  myBLE.startNotifications(myCharacteristic, handleNotifications);
  // You can also pass in the dataType
  // Options: 'unit8', 'uint16', 'uint32', 'int8', 'int16', 'int32', 'float32', 'float64', 'string'
  // myBLE.startNotifications(myCharacteristic, handleNotifications, 'string');

  // Check if myBLE is connected
  isConnected = myBLE.isConnected();
  if (isConnected) {
    document.getElementById("continue").style.visibility = "visible";
    document.getElementById("connected").style.visibility = "visible";
  }
  // Add a event handler when the device is disconnected
  myBLE.onDisconnected(onDisconnected)
}

// A function that will be called once got characteristics
function handleNotifications(data) {
  myValue = data;
  if (myValue == 0 | myValue == 1 | myValue == 2) {
    identifier = myValue;
  } else {
    incomingValues[identifier] = myValue;
  }
  //console.log(identifier, incomingValues[identifier]);
  readValues();

}

function readValues() {
  //check if there is at least one token available
  console.log(incomingValues);
  if (arrayEquals(incomingValues, emptyArray)) {
    open1Page(0);
  }
  if (!arrayEquals(incomingValues, tags)) { //if something changed after the previous situation
    removeTags();
    updateTags();
  }
} //function

function removeTags() {
  for (let i = 0; i < incomingValues.length; i++) {
    //console.log(tags);
    if (incomingValues[i] == 255 && tags[i] != 255) {
      //if no tag present on reader[i], then remove one tag present and remove value from tag[]
      console.log("tag removed");
      tagRemoved = true;
      tagsPresent--;
      tags[i] = 255;
      loc[i] = 0; // 1: tag is present, 0: no tag present
      updateTags();
    } //if

  } //for
}

function updateTags() {
  if (!arrayEquals(incomingValues, emptyArray)) {
    //console.log("At least one tag present!");
    //loop over the incomingValues to detect how many tags are present, their location and their ID.
    for (let i = 0; i < incomingValues.length; i++) {
      //console.log(i, incomingValues[i]);
      //check if != 255 --> token present
      if (incomingValues[i] != 255) {
        //console.log("Tag present");
        if (incomingValues[i] != tags[i]) { //only for new tags
          tagsPresent++; //add 1 to number of tagsPresent
          tags[i] = incomingValues[i]; //save the tag number for identification later
          loc[i] = 1; // 1: tag is present, 0: no tag present
          numPages(tags[i]);
        } else if (tagRemoved) { //if a tag is removed, the if-loop above will not rerun since the remaining token is the same, so in that case run this elseif
          tags[i] = incomingValues[i];
          numPages(tags[i]);
          tagRemoved = false;
        }
      } //if
    } //for
  }
}

function numPages(tagID) {
  switch (tagsPresent) {
    case 1: //1 tag present if loc[0]: data, loc[1]: label, loc[2]: ability
      //show data or ability page depending on token
      console.log("1 tag present");
      open1Page(tagID);
      break;
    case 2: //2 tags present
      // check if unsupervised: if yes show combination page of data + ability, loc[1] should be empty
      // if supervised and no label --> alert place label
      // if supervised and label --> show ability page
      console.log("2 tags present");
      tag1 = tags.find(findTag);
      tag2 = tags.slice().reverse().find(findTag);
      tag3 = 0;
      openCombiPage(tag1, tag2, tag3);
      break;
    case 3: //3 tags present, should be data+label+supervised --> show combination page
      console.log("3 tags present");
      tag1 = tags[0];
      tag2 = tags[1];
      tag3 = tags[2];
      openCombiPage(tag1, tag2, tag3);
      break;
    default: //0 tags
  }
}

function open1Page(tagID) {
  if (tagID == 0) {
    openInfo();
  } else if (dataTokens.includes(tagID)) {
    labelPresent = false;
    //  openDataPage(transform('datatypes.xml', 'datatokens.xsl', 'Text'));
    openDataPage(transform('datatypes.xml', 'datatokens.xsl', tagID));
    sendOOCSI('datapage', tagID);
  } else if (abilityTokens.includes(tagID)) {
    labelPresent = false;
    openAbilityPage(transform('abilities.xml', 'abilities.xsl', tagID));
    sendOOCSI('abilitypage', tagID);
  } else if (labelTokens.includes(tagID)) {
    labelPresent = true;
    openInfo();
    console.log("label present");
  } else {
    openInfo();
    alert('Token not recognized');
  }
}


function openCombiPage(tag1, tag2, tag3) {
  if (tag3 == 0) { //case of two tokens present
    if (dataTokens.includes(tag1) && abilityTokens.includes(tag2)) {
      labelPresent = false;
      if (unsupTokens.includes(tag2)) {
        console.log("Unsupervised");
        openCombinationPage(transform2('combies.xml', 'combies.xsl', tag1, tag2));
      } else if (supTokens.includes(tag2)) {
        alert("This combination requires the presence of labels, please place this token");
      }
    } else if (dataTokens.includes(tag1) && labelTokens.includes(tag2)) {
      labelPresent = true;
      openDataPage(transform('datatypes.xml', 'datatokens.xsl', tag1));
    } else if (labelTokens.includes(tag1) && abilityTokens.includes(tag2)) {
      labelPresent = true;
      openAbilityPage(transform('abilities.xml', 'abilities.xsl', tag2)); //with tag2
    } else {
      openInfo();
      labelPresent = false;
      alert('This is not a correct/possible combination ');
    }
  } else { //case of 3 tokens
    labelPresent = true;
    openCombinationPage(transform2('combies.xml', 'combies.xsl', tag1, tag3));
  }
}

//source: https://masteringjs.io/tutorials/fundamentals/compare-arrays
function arrayEquals(a, b) {
  return Array.isArray(a) &&
    Array.isArray(b) &&
    a.length === b.length &&
    a.every((val, index) => val === b[index]);
}

function findTag(tag) {
  return tag != 255;
}
