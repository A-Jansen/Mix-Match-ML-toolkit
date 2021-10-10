const serviceUuid = "e098a7b1-9074-4e8f-bb89-2a8e84a1a271";
let isConnected = false;
var connectButton;
var disconnectButton;

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

  // Check if myBLE is connected
  isConnected = myBLE.isConnected();
  if (isConnected) {
    document.getElementById("continue").style.visibility = "visible";
    document.getElementById("connected").style.visibility = "visible";
  }
  // Add a event handler when the device is disconnected
  myBLE.onDisconnected(onDisconnected)
}
