<?php Header("Cache-Control: max-age=300, must-revalidate"); ?>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">

	<title>M2.1</title>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.7.2/p5.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/0.7.2/addons/p5.dom.min.js"></script>
	<script src="https://unpkg.com/p5ble@0.0.4/dist/p5.ble.js"></script>

	<!--<script src="sketch.js"></script>-->
	<script type="text/javascript" src="libraries/jquery.min.js"></script>
	<script type="text/javascript" src="libraries/oocsi-web.js"></script>
  <script type="text/javascript" scr="script.js"></script>
	<script src="BLEconnect.js"></script>
	<link href="/assets/css/fonts.css" type="text/css" rel="stylesheet">
	<link href="/assets/css/homepage.css" type="text/css" rel="stylesheet">


	<!-- <link rel="preconnect" href="https://fonts.gstatic.com"> -->
	<!-- <link href="https://fonts.googleapis.com/css2?family=Work+Sans:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet"> -->
	<link rel="stylesheet" type="text/css" href="//fonts.googleapis.com/css?family=Lato" />
</head>


<!--The whole body will be replaced by the XMLHttpRequest to go to the information page-->
<body id='replace'>
			<header>
				<h1 id='welcome'>Welcome</h1>
			</header>
	<div class=centerBlock>
		<div>
			<p>Before you can start, you need to enter your participant/group information
				and connect your laptop to the sensor board. Follow the next steps to get ready. </p>
				<h3>Enter your group/ participant number:	</h3>
					<input type="number" name="IDnumber" id='ID'><br>
				<div>
					<h3>Connect to board</h3>
					<a id=connectBLE href="#">Connect </a><span id='connected'>Succesfully connected to board</span>
				</div>
		</div>
		<div>
		<!-- Will only be shown once connected (change in.continue in css to hidden) -->
		<a href="#" id='continue' onClick="openInfo()">Continue</a>
		</div>
		<p id='demo'></p>
	</div>


<script>
var IDnumber; //for logging each session to oocsi so it can be identified for analyses
let ready=false; //use to not skip the setup page by pressing key or placing tokens

//When you click continue, the body will be replaced with the page from infopage.php, but you stay at the same page so the BLE connection does not get broken
function openInfo() {
	if (!ready){
		ready=true;
		IDnumber= document.getElementById('ID').value;
		console.log("ID number: "+ IDnumber);
	}
	var xhttp = new XMLHttpRequest();
  xhttp.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("replace").innerHTML = this.responseText;
    }
  };
  xhttp.open("GET", "infopage.php", true);
  xhttp.send();
}

//Control the pages for now with keys, replace once tokens work
var key = function(e) {
		e = e || window.event;
	var k = e.keyCode || e.which;
	// console.log(k);
	if(ready){
		switch (k) {
			case 68: //68=d=data
				console.log('data page');
				openDataPage();
				break;
			case 65: //65=a=abilityPage
				console.log('model ability page');
				openAbilityPage();
				break;
			default:
			console.log('back to infopage');
			openInfo();
		}
	}
};
document.onkeydown = key;

//open the datapage when pressed on 'd or when a data token is placed
function openDataPage() {
	var xhttpData = new XMLHttpRequest();
  xhttpData.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("replace").innerHTML = this.responseText;
    }
  };
  xhttpData.open("GET", "dataPage.php", true);
  xhttpData.send();
}

//open the ML ability page when 'a' is pressed or when a ML ability token is placed
function openAbilityPage() {
	var xhttpAbility = new XMLHttpRequest();
  xhttpAbility.onreadystatechange = function() {
    if (this.readyState == 4 && this.status == 200) {
      document.getElementById("replace").innerHTML = this.responseText;
    }
  };
  xhttpAbility.open("GET", "abilityPage.php", true);
  xhttpAbility.send();
}

</script>

</body>

</html>
