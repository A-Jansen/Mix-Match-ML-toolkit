# Mix & Match ML toolkit
This github repository contains the relevant codes, schematics and files used to create your own sensorboard and tokens to be used with the Mix & Match ML website. The code for the website is provided and can be used to create versions tailored to yourproject. 

![alt text](https://github.com/A-Jansen/M21/blob/main/system%20overview.jpg)
## Website 
To visit the website click [here](https://a-jansen.github.io/) <br>
The website uses XML files to store all the information about all the tokens and combinations. XSLT and CSS is used to format this information and each time a token is placed or removed the site is updated using AJAX. This is done to keep the sensor board connected via BLE. 
In order to find the sensor board, the serviceUUID should be the same in the BLEconnect.js file and the Arduino code uploaded to the microcontroller.


## Sensorboard
The sensorboard contains two RFID readers to read the tokens. Custom versions of the sensorboard can be used, here two options will be shown: (i) using an ESP32-wrover with build in battery holder and (ii) using an Arduino Nano 33 IoT with powerbank.
The necessary code and files for making the sensorboard can be found in the folder [sensor board](https://github.com/A-Jansen/M21/tree/main/sensor%20board). This includes the Arduino code used, the Illustrator files for lasercutting the box (and tokens) and the schematic of the electronics.

### Materials
<ul>
  <li>4 mm MDF or another firm material suited for lasercutting</li>
  <li>2 mm MDF or another firm material suited for lasercutting</li>
  <li>Mircontroller<li>
    <ul>
      <li>LilyGO TTGO T-Energy ESP32-WROVER</li>
      <li>Arduino Nano 33 IoT</li>
      <li>Or any other microntroller with BLE and SPI (not tested)</li>
      </ul>
  <li>18650  battery/ powerbank/ any other powersource</li>
  <li>2x MFRC522 RFID readers</li>
  <li>On-off switch</li>
  <li>Optional: extension cable from male micro usb to female mirco usb</li>
</ul>

### Assembly
Glue the box togehter: one side, and the top is made out of 2 layers 2mm MDF, glue these first together. Next attach the sides to the bottom, do not attach the the top so you can still access the electronics.
Solder all components to protoboard, soldering is prefered over using a breadboard since this works better/more reliable with the SPI communication of the RFID readers.
Take the placement of the RFID readers into account, they should be placed directly under the cut out rounded rectangle in which the tokens will be placed. Best to attach them directly underneath the top plate for a more reliable reading. 
  
### Code
Depending on the microcontroller you are using, upload the ESP or Arduino version of the code. You can change the name of the board to a custom name. <br>
Make sure that the serviceUUID in the Arduino code should be the same as in the BLEconnect.js file in order to find the sensorboard via the website. 


## Tokens
The tokens are made of two layers (4 mm and 2mm) mdf and 3mm synthetic felt with Mifare classic 1K tags as stickers attached at the bottom. The files for lasercutting can be found [here](https://github.com/A-Jansen/M21/tree/main/sensor%20board/Files%20for%20lasercutting).

### Materials
<ul>
  <li>4 mm MDF or another firm material suited for lasercutting</li>
  <li>2 mm MDF or another firm material suited for lasercutting</li>
  <li>3 mm synthetic felt in 5 different colours (2 tints blue, 3 tints green). Wool felt does not work well</li>
  <li>24 Mifare classic 1K stickers (as many as there are tokens) </li>
</ul>

### Assembly
Assemble the tokens by glueing them together, with the 4mm MDF at the bottom next the 2mm MDF and as top layer the felt. 
See the image for which shapes to combine. 

![alt text](https://github.com/A-Jansen/M21/blob/main/sensor%20board/assembling%20tokens.jpg)

### Writing ID numbers to your tags
When creating your own version, you first need to initialize all the tokens by giving writing the correct ID numbers to them. The assigned numbers can be found [here](https://github.com/A-Jansen/Mix-Match-ML-toolkit/blob/main/Token%20id's.xlsx). To write he numbers you can use [this](https://github.com/miguelbalboa/rfid/tree/master/examples/rfid_write_personal_data) example code. 
