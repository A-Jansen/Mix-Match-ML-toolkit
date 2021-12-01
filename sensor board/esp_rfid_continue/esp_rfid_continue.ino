/*WORKS!!!! :)
   Created by esp32io.com

   This example code is in the public domain

   Tutorial page: https://esp32io.com/tutorials/esp32-rfid-nfc
   Combined with:  * Example sketch/program showing how to read new NUID from a PICC to serial.
*/

#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN  21  // ESP32 pin GIOP5 
#define RST_PIN 34 // ESP32 pin GIOP27 
#define READ_RATE 5
long timer = micros(); //timer

boolean cardPresent = false;

// Init array that will store new NUID
int nuidPICC[4];


MFRC522 rfid(SS_PIN, RST_PIN);

void setup() {
  Serial.begin(9600);
  SPI.begin(); // init SPI bus
  rfid.PCD_Init(); // init MFRC522

 // Serial.println("Tap RFID/NFC Tag on reader");
}

void loop() {
  if (micros() - timer >= (1000000 / READ_RATE) ) { //Timer: send sensor data in every
    timer = micros();
   // Serial.println(rfid.PICC_IsNewCardPresent());
    if (rfid.PICC_IsNewCardPresent()) { // new tag is available
      if (rfid.PICC_ReadCardSerial()) { // NUID has been readed
        MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);
        //Serial.print("RFID/NFC Tag Type: ");
        //Serial.println(rfid.PICC_GetTypeName(piccType));
        for (int i = 0; i < 4; i++) {
          nuidPICC[i] = rfid.uid.uidByte[i];
        }

      }
    } else {
      for (int i = 0; i < 4; i++) {
        nuidPICC[i] = 30;
      }
    }


    //rfid.PICC_HaltA(); // halt PICC
    rfid.PCD_StopCrypto1(); // stop encryption on PCD
    Serial.println(nuidPICC[0]);
    if (nuidPICC[0] == 30) {
      Serial.println("No Tag");
    } else {
      //Serial.print(F("In dec: "));
      //printDec(rfid.uid.uidByte, rfid.uid.size);
    for(int i = 0 ; i < 4 ; i++){
        Serial.print(nuidPICC[i]);
        Serial.print(',');
      }
      Serial.println();
    }
   // rfid.PICC_HaltA(); 
  }
}

/**
   Helper routine to dump a byte array as hex values to Serial.
*/
void printHex(byte * buffer, byte bufferSize) {
  for (byte i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], HEX);
  }
}


/**
   Helper routine to dump a byte array as dec values to Serial.
*/
void printDec(byte * buffer, byte bufferSize) {
  for (int i = 0; i < bufferSize; i++) {
    Serial.print(buffer[i] < 0x10 ? " 0" : " ");
    Serial.print(buffer[i], DEC);
    Serial.print(',');
  }
}
