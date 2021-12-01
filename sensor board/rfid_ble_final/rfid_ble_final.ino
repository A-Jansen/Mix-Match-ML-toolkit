/**
   Code for the LilyGO TTGO T-Energy ESP32-WROVER used in the sensor board to read the tag ID's from two RFID readers and communicate these via BLE.
   A button with internal LED is used to put the ESP in deepsleep to save energy when not being used (altnerative is the switch on the ESP itself to completely shut it off).

   The following libraries and examples are used:
   ReadUidMultiReader.ino from the MFRC522 library by Miguel Balboa, see: https://github.com/miguelbalboa/rfid
   Used for reading multiple RFID readers

   Example code for notifications via BLE:
    Video: https://www.youtube.com/watch?v=oCMOYS71NIU
    Based on Neil Kolban example for IDF: https://github.com/nkolban/esp32-snippets/blob/master/cpp_utils/tests/BLE%20Tests/SampleNotify.cpp
    Ported to Arduino ESP32 by Evandro Copercini
    updated by chegewara

  Example code for putting the ESP in deep sleep with external wake up from  Pranav Cherukupalli <cherukupallip@gmail.com>
*/


//Setup for RFID readers
#include <SPI.h>
#include <MFRC522.h>

//Pins are specific for each board, see for more pin layouts: https://github.com/miguelbalboa/rfid#pin-layout
#define RST_PIN         34
#define SS_1_PIN        21         // the SS pins should be an SDA or SCO pin on the ESP wrover, these are pins 21,5,15
#define SS_2_PIN        15         // the SS pins should be an SDA or SCO pin on the ESP wrover, these are pins 21,5,15

#define NR_OF_READERS   2

byte ssPins[] = {SS_1_PIN, SS_2_PIN};

// Init array that will store new NUID from all three readers
int reader1[4];
int reader2[4];

int combinedReader[2]; // combine all readings, take either only one value or increase to 12 to use all values
bool checkEmpty[2] = {false, false};
byte result = 0;

#define READ_RATE 5
long timer = micros(); //timer

MFRC522 mfrc522[NR_OF_READERS];   // Create MFRC522 instance.

//Setup BLE
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
uint32_t value = 0;
String identifier;
// See the following for generating UUIDs:
// https://www.uuidgenerator.net/

#define SERVICE_UUID        "e098a7b1-9074-4e8f-bb89-2a8e84a1a271"
#define CHARACTERISTIC_UUID "4be50649-c0d7-43e0-a70c-fbf31945b95f"

class MyServerCallbacks: public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer* pServer) {
      deviceConnected = false;
    }
};


//Setup for the wake/sleep button
RTC_DATA_ATTR int bootCount = 0;
int button = GPIO_NUM_32; //button to turn esp in deepsleep, needs to be a GPIO pin
int onoff;

void print_wakeup_reason() {
  esp_sleep_wakeup_cause_t wakeup_reason;

  wakeup_reason = esp_sleep_get_wakeup_cause();

  switch (wakeup_reason)
  {
    case ESP_SLEEP_WAKEUP_EXT0 : Serial.println("Wakeup caused by external signal using RTC_IO"); break;
    case ESP_SLEEP_WAKEUP_EXT1 : Serial.println("Wakeup caused by external signal using RTC_CNTL"); break;
    case ESP_SLEEP_WAKEUP_TIMER : Serial.println("Wakeup caused by timer"); break;
    case ESP_SLEEP_WAKEUP_TOUCHPAD : Serial.println("Wakeup caused by touchpad"); break;
    case ESP_SLEEP_WAKEUP_ULP : Serial.println("Wakeup caused by ULP program"); break;
    default : Serial.printf("Wakeup was not caused by deep sleep: %d\n", wakeup_reason); break;
  }
}


/**
   Initialize.
*/
void setup() {

  Serial.begin(9600); // Initialize serial communications with the PC
  pinMode(button, INPUT);

  //Increment boot number and print it every reboot
  ++bootCount;
  Serial.println("Boot number: " + String(bootCount));

  //Print the wakeup reason for ESP32
  print_wakeup_reason();
  esp_sleep_enable_ext0_wakeup(GPIO_NUM_32, 1); //1 = High, 0 = Low
  while (!Serial);    // Do nothing if no serial port is opened (added for Arduinos based on ATMEGA32U4)

  SPI.begin();        // Init SPI bus
  delay(400);
  for (uint8_t reader = 0; reader < NR_OF_READERS; reader++) {
    mfrc522[reader].PCD_Init(ssPins[reader], RST_PIN); // Init each MFRC522 card
    delay(100);
    Serial.print(F("Reader "));
    Serial.print(reader);
    Serial.print(F(": "));
    mfrc522[reader].PCD_DumpVersionToSerial();
  }

  //BLE setup
  Serial.println("Starting BLE work!");

  // Create the BLE Device
  BLEDevice::init("Sensor board");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ   |
                      BLECharacteristic::PROPERTY_WRITE  |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE
                    );

  // https://www.bluetooth.com/specifications/gatt/viewer?attributeXmlFile=org.bluetooth.descriptor.gatt.client_characteristic_configuration.xml
  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(true);
  pAdvertising->setMinPreferred(0x0);  // set value to 0x00 to not advertise this parameter
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

/**
   Main loop.
*/
void loop() {
  onoff = digitalRead(button);
  delay(50);
  if (onoff == 0) {
    //Go to sleep now
    sendIdentifier(254);//send 254 to tell the website to break the connection
    delay(10);
    Serial.println("Going to sleep now");
    esp_deep_sleep_start();
    Serial.println("This will never be printed");
  }
  RFIDreaders();

}

void RFIDreaders() {

  if (micros() - timer >= (1000000 / READ_RATE) ) { //Timer reduce number of reading per second
    timer = micros();
    //Loop over all readers
    for (uint16_t reader = 0; reader < NR_OF_READERS; reader++) {

      if (mfrc522[reader].PICC_IsNewCardPresent()) {
        if (mfrc522[reader].PICC_ReadCardSerial()) {
          checkEmpty[reader] = false;
          combinedReader[reader] = mfrc522[reader].uid.uidByte[1]; //save the second byte from the UID in the array (location 0=reader0);
          // Halt PICC --> don't want this, continuous readings needed
          //mfrc522[reader].PICC_HaltA();
          // Stop encryption on PCD
          mfrc522[reader].PCD_StopCrypto1();
        }
      }//Card is not new for one reading, prevent this behaviour by checking if it was -1 (if yes it is really empty) and prevent getting stuck in loop, use boolean to only allow 1 false empty reading
      else if (!mfrc522[reader].PICC_IsNewCardPresent() && combinedReader[reader] != -1 && !checkEmpty[reader]) {
        combinedReader[reader] = -1;
        checkEmpty[reader] = true;
      }
      //Loop through all the reading and send the identifier (0,1) and the tag id, also print them in the serial monitor for debugging
      for (int i = 0; i < 2; i++) {
        sendValues(i);  //send the identifier
        sendValues(combinedReader[i]); //send the tag ID
        Serial.print(combinedReader[i]);
        Serial.print(',');
      }
      Serial.println();
    }
  }
}

//send the identifier or tag ID via BLE
void sendValues(int value) {
  if (deviceConnected) {
    pCharacteristic->setValue((uint8_t*)&value, 4);
    pCharacteristic->notify();
    //  value++;
    delay(50); // bluetooth stack will go into congestion, if too many packets are sent, in 6 hours test i was able to go as low as 3ms
  }
  // disconnecting
  if (!deviceConnected && oldDeviceConnected) {
    delay(500); // give the bluetooth stack the chance to get things ready
    pServer->startAdvertising(); // restart advertising
    Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;
  }
  // connecting
  if (deviceConnected && !oldDeviceConnected) {
    // do stuff here on connecting
    oldDeviceConnected = deviceConnected;
  }

}

/**
   Helper routine to dump a byte array as hex values to Serial.
*/
void dump_byte_array(byte *buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}

//Function that can be used for debugging and to see all NUID values of the tags.
void printInd(uint8_t reader) {
  switch (reader) {
    case 0:
      Serial.print("Reader1: ");
      combinedReader[0] = mfrc522[reader].uid.uidByte[3];
      for (int i = 0; i < 4; i++) {
        reader1[i] = mfrc522[reader].uid.uidByte[i];
        Serial.print(reader1[i]);
        Serial.print(',');
      }

      Serial.println();
      break;
    case 1:
      Serial.print("Reader2: ");
      combinedReader[1] = mfrc522[reader].uid.uidByte[3];
      for (int i = 0; i < 4; i++) {
        reader2[i] = mfrc522[reader].uid.uidByte[i];
        Serial.print(reader2[i]);
        Serial.print(',');
      }

      Serial.println();
      break;
    case 2:
      Serial.print("Reader3: ");
      combinedReader[2] = mfrc522[reader].uid.uidByte[3];
      for (int i = 0; i < 4; i++) {
        reader3[i] = mfrc522[reader].uid.uidByte[i];
        Serial.print(reader3[i]);
        Serial.print(',');
      }

      Serial.println();
      break;

  }
}
