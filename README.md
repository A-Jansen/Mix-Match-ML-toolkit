# M21 Project Anniek Jansen
This github repository contains the relevant codes, schematics and files to recreate the sensor board and the website.

## Website 
The code for the website can be found in the folder "website". 


## Sensor board
The necessary code and files for making the sensor board can be found in the folder "sensor board". This includes the Arduino code used, the Illustrator files for laser cutting the box and the schematic of the electronics.

### Materials
<ul>
  <li>4 mm MDF or another firm material suited for lasercutting</li>
  <li>2 mm MDF or another firm material suited for lasercutting</li>
  <li>LilyGO TTGO T-Energy ESP32-WROVER</li>
  <li>18650  battery</li>
  <li>2x MFRC522 RFID readers</li>
  <li>Optional: on and off button (with internal LED): https://www.tinytronics.nl/shop/nl/schakelaars/manuele-schakelaars/drukknoppen-en-schakelaars/metalen-drukknop-16mm-aan-uit-met-3v-groene-led-verlichting</li>
  <li>Optional: extension cable from male micro usb to female mirco usb</li>
</ul>

### Assembly
Glue the box togehter, one side, and the top is made out of 2 layers 2mm mdf. Do not attach the the top so you can still access the electronics.
Solder all components to a perfboard, soldering is prefered over using a breadboard since this works less well with the SPI communication of the RFID readers.
Take the placement of the RFID readers into account, they should be placed directly under thecut out rounded rectangle in which the tokens will be placed. Best to attach them to the top for a reliable reading.


## Tokens
The tokens are made of two layers (4 mm and 2mm) mdf and 3mm synthetic felt with Mifare classic 1K tags as stickers attached at the bottom. 

### Materials
<ul>
  <li>4 mm MDF or another firm material suited for lasercutting</li>
  <li>2 mm MDF or another firm material suited for lasercutting</li>
  <li>3 mm synthetic felt in 5 different colours (2 tints blue, 3 tints green). Wool felt does not work well</li>
  <li>Mifare classic 1K stickers, as many as there are tokens </li>
</ul>

### Assembly
Assemble the tokens by having them glued in the following order (top down): felt, 2mm mdf, 4mm mdf.<br>
The tokens for unlabeled data, supervised learning and reinforcement learning use thrice the same shape. The tokens for labeled data have a larger 4mm base (with the word labels engraved) and smaller 2mm MDF and felt layers. The unsupervised learning tokens have the same 4mm base as the supervised learning tokens, but have a 2mm MDF and felt layer that cover the cut out triangle. 
