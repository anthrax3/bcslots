---------------------------------------------------------------------------
---------------------------------------------------------------------------
slot_machine by Daniel Sadowski (info@bitemedia.com)
---------------------------------------------------------------------------
---------------------------------------------------------------------------
An all-vector, scaleable, slot machine game reminiscent of the old-style 1-payline, 3-reel, 6-icon machines.

An XML configuration file controls:
* button colors (off, up, over states)
* individual sound effect levels (spin, stop, coin drop, handle pull, winner loop)

It is possible to change the following within Flash:
* Payout amounts for each winning spin
* Payout odds by adjusting an array containing each reel's icon frequency. So for example, you could increase the likelihood of a '777' jackpot by increasing the number of 7s on each reel's icon array.
* The slot machine's vector reel icons
* The slot machine's 'skin'
* Money/Credit initial and reset amount

The file uses a Flash-based Shared Object 'cookie' to store the user's score.

View the file in action here:
http://www.bitemedia.com/slot_machine/

*Note:* this file is for fun only - because the payout amounts and winning spin odds could possibly be spoofed, the file should not be used in any type of prize give-away situation.

All sound effects are licensed from AudioSparx:
http://www.audiosparx.com/


----------------------------------------------------------------------
Included in the Zip file:
----------------------------------------------------------------------

Documentation:
----------------------------------------------------------------------
slot_machine_readme.txt (the file you are reading now)
slot_machine_readme.rtf (an RTF version of the file you are reading now)



Flash Files:
----------------------------------------------------------------------
slot_machine.fla (Flash CS3 source file)
slot_machine_f8.fla (Flash 8 source file)
slot_machine.swf (.SWF file)
slot_machine_config.xml (XML config file)



HTML, CSS and JavaScript Files:
----------------------------------------------------------------------
Upload these files along with your .SWF and XML files:

index.html (HTML index file)
_styles/main.css (CSS file used in index.html)
swfobject.js (SWFObject 2.0 JavaScript file used for embedding the .SWF)



Tweener Class Files:
----------------------------------------------------------------------
This folder contains the AS 2.0 Tweener Class files necessary for the any tweening animation used in the file. Note: This folder does not need to be uploaded to your server in order for the .SWF to function properly. However, if you are going to be editing the .FLA file, the caurina folder plus all sub-folders need to be located in the same folder as your .FLA.

caurina folder

More information about the Tweener Class can be found here:
http://hosted.zeh.com.br/tweener/docs/en-us/



Park-Miller-Carta Pseudo-Random Number Generator Class Files:
----------------------------------------------------------------------
This folder contains the AS 2.0 Park-Miller-Carta Pseudo-Random Number Generator Class files necessary for the random number generation used in the file. Note: This folder does not need to be uploaded to your server in order for the .SWF to function properly. However, if you are going to be editing the .FLA file, the de folder plus all sub-folders need to be located in the same folder as your .FLA.

de folder

More information about the Michael Baczynski's implementation of the Park-Miller-Carta Pseudo-Random Number Generator Class can be found here:
http://lab.polygonal.de/2007/04/21/a-good-pseudo-random-number-generator-prng/

More information about the Park-Miller-Carta Pseudo-Random Number Generator can be found here:
http://www.firstpr.com.au/dsp/rand31/






----------------------------------------------------------------------
Modifying the Flash file:
----------------------------------------------------------------------
Changing some slot machine features requires opening and editing the .FLA:



Changing the reel icons
----------------------------------------------------------------------
- open the .FLA in Flash
- in the Library window open this folder: slot_machine/REELS/REEL Icons
- you will see the following symbols:

00-any (used in the Payout Table)
01-cherries
02-orange
03-plum
04-bell
05-bar
06-seven

Try to keep any new icons the same relative size as the current ones. The size of each reel window is 86 pixels wide by 106 pixels high so the new icon size should be limited to a maximum of 80 x 80 pixels.

Using icons with more of a square aspect ratio is a good idea - icons that are too tall will make your reels look cramped.

Like the rest of the graphic elements, the reel icons are vector-based. You could however use bitmap images or photos instead - just remember not to use scaling on your .SWF when embedding it in your HTML file or else your reel icons could look pixelated.



Changing the reel background color
----------------------------------------------------------------------
- open the .FLA in Flash
- in the Library window open this folder: slot_machine/WINDOW Graphics
- you will see the WINDOW_bg symbol - adjusting this symbol will affect the background color of all 3 reels 



Changing the slot machine's 'skin'
----------------------------------------------------------------------
- open the .FLA in Flash
- in the Library window open this folder: slot_machine/SKIN
- you will see the •SKIN comp symbol which is a composition of slot machine elements

The 'stroke_reels' Layer contains the borders that outline the 3 reel windows. If you change the position of any of the reels (located on the slot_machine_mc Timeline) you may need to adjust the position of these borders.

The 'stroke_digital_display' Layer contains the borders that outline the CREDITS, BET and WINNER PAID digital displays. If you change the number of digits in any of the digital displays (located on the slot_machine_mc Timeline) you may need to adjust the width of these borders.



Changing the digital displays
----------------------------------------------------------------------
If you'd like change the number of digits in any of the 3 digital displays (money_counter_mc, coins_played_mc, payout_counter_mc):

- in the Main Timeline, double-click on the 'slot_machine_mc' MovieClip (on the 'slot_machine' Layer)
- single-click on Frame 4 (labelled 'initMoney') of the 'Actions' Layer and open your Actions window
- change any of the 3 .numbersMax variables to new values
- remember to adjust the borders that outline the CREDITS, BET and WINNER PAID digital displays (see Changing the slot machine's 'skin' above)

You can also add a glow to any of the displays by changing its glow variables. However this could affect playback performance as there's a lot of other stuff going on - the default glowBlurRadius is 0 which prevents any Glow from being applied at all):

.glowAlpha = 0; // set between 0 and 1 (0.5 is 50% opacity)
.glowBlurRadius = 0; // set between 0 and 255 (Values that are a power of 2 render faster)
.glowStrength = 0; // set between 0 and 255 (A setting between 0 and 1 usually looks best)
.glowQuality = 1; // set to 1 (low quality), 2 (medium quality), 3 (high quality)



Changing the Initial and Reset Money values
----------------------------------------------------------------------
- in the Main Timeline, double-click on the 'slot_machine_mc' MovieClip (on the 'slot_machine' Layer)
- single-click on Frame 3 (labelled 'functions') of the 'Actions' Layer and open your Actions window
- on lines 79 through 80 you'll see:

var moneyInit_num:Number = 100;
var moneyReset_num:Number = moneyInit_num;

Change these values to increase or decrease the initial and reset money values.



Bitmap Caching
----------------------------------------------------------------------
The slot machine's skin uses the Flash Player's cacheAsBitmap property in order to improve playback performance. According to Adobe, …"if set to true, Flash Player caches an internal bitmap representation of the movie clip. This can increase performance for movie clips that contain complex vector content…"



Changing the Payout Table graphic
----------------------------------------------------------------------
The Payout Table fades on when you click the PAY TABLE button and displays the payouts for 1,2 and 3 coins played. The numbers are dynamic text fields that are automatically populated by the variables on line 87 through 94 of Frame 3 of the 'slot_machine_mc' MovieClip :

var payoutLevel_1_num:Number = 2;
var payoutLevel_2_num:Number = 5;
var payoutLevel_3_num:Number = 10;
var payoutLevel_4_num:Number = 12;
var payoutLevel_5_num:Number = 20;
var payoutLevel_6_num:Number = 50;
var payoutLevel_7_num:Number = 100;
var payoutLevel_8_num:Number = 250;

…the 2nd coin column amount is double the corresponding 1st coin column amount while the 3rd coin column amount is triple the corresponding 1st coin column amount.

The 'mini' icons displayed are scaled down versions of the full-size icons. So, if you have changed any of the icons but have retained the same relative size as the current ones and have not added new icons to the reels, then the Payout Table should take care of itself. If you'd like to change the look & feel/colors etc.:

- in the Library window open this folder: slot_machine/PAY TABLE
- you will see the •PAY TABLE Comp and paytable_BG symbols to edit



Adding icons to each reel
----------------------------------------------------------------------
It's possible to add icons to each reel so that there are more than 6 per reel but the process is complex. Newer versions of this file may make this process more user-friendly but for now this is the only way and requires some ActionScript knowledge. For example, to add a seventh icon to each reel:

Add a new reel icon symbol in the Library window
- open the .FLA in Flash
- in the Library window open this folder: slot_machine/REELS/REEL Icons
- duplicate the 06-seven symbol and name it 07-new_icon
- import your new icon graphics into the 07-new_icon symbol (remember to center it and keep its size similar to the other existing icons)
- in the Library window, right-click (Mac: control-click) on the new symbol and select Linkage… from the menu
- check the Export for ActionScript checkbox and uncheck the Export in first frame checkbox
- enter 'reel_icon_7' into the Identifier field then click OK
- important: since the new symbol is not being exported in the first frame, you'll need to place it on the Stage somewhere so that it is actually included when the .SWF is compliled


Change each reel's icon array
- in the Main Timeline, double-click on the 'slot_machine_mc' MovieClip (on the 'slot_machine' Layer)
- single-click on Frame 3 (labelled 'functions') of the 'Actions' Layer and open your Actions window
- on lines 128 through 131 you'll see:

// REEL ICON VALUES
var reel_1_icon_array:Array = new Array(6, 4, 3, 5, 2, 1);
var reel_2_icon_array:Array = new Array(6, 4, 5, 3, 2, 1);
var reel_3_icon_array:Array = new Array(6, 3, 2, 4, 1, 5);

A reference to the new seventh icon needs to be inserted into each array - the spinning reel 'tile' is generated based on these arrays. Adding a 7 to the end of each array will add the new seventh icon to each reel 'tile' (each array must contain the same number of items):

// REEL ICON VALUES
var reel_1_icon_array:Array = new Array(6, 4, 3, 5, 2, 1, 7);
var reel_2_icon_array:Array = new Array(6, 4, 5, 3, 2, 1, 7);
var reel_3_icon_array:Array = new Array(6, 3, 2, 4, 1, 5, 7);


Change each reel's virtual icon weighting array
These arrays control the probability of each reel landing on a particular icon (see Changing the payout percentage for the machine below for an explanation of 'virtual reels'). The numbers in the arrays represent index positions from the reel icon arrays. The greater the number of instances of one icon's index position, the greater the probability of the reel landing on that icon. So for example, if you look on line 135 of Frame 3 of the Main Timeline you'll see:

var reel_1_virtual_array:Array = new Array(1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6, 6, 6, 6);

The first two numbers in the array (1, 1) represent position 1 in reel_1_icon_array: icon 6, which is the 'Lucky 7' icon. Notice that the next twelve numbers are 2, which represent position 2 in reel_1_icon_array: icon 4, the 'Bell' icon. So, reel 1 is much more likely to land on the 'Bell' icon compared to the 'Lucky 7' icon.

On lines 134 through 137 of Frame 3 of the Main Timeline, add one 7 item to the end of the array (each array must contain the same number of items):

// REEL ICON POSITION WEIGHTS
var reel_1_virtual_array:Array = new Array(1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6, 6, 6, 6, 7);
var reel_2_virtual_array:Array = new Array(1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6, 7);
var reel_3_virtual_array:Array = new Array(1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5, 5, 5, 6, 7);


Change the payout logic
Payouts are determined by a series of if/then statements that check to see if the final positions of the reels match up. On Frame 3 of the Main Timeline, scroll down to view lines 306 through 379, the fncCheckPayout() function. You'll need to add in a new if/then block and any new payoutLevel variables.

For example, add in a new payoutLevel variable after line 94:
var payoutLevel_9_num:Number = 250;

…and change:
var payoutLevels_num:Number = 8;

…to:
var payoutLevels_num:Number = 9;

Then add a new if/then block to check if each reel's final position has landed on your new icon (scroll down to // ICON 7: New Icon):

// --------------------------------------------------
// CHECK PAYOUT FUNCTION
// --------------------------------------------------
function fncCheckPayout():Void {
	payoutCurrent_num = 0;
	payoutDisplay_num = payoutCurrent_num;
	fncSetPayoutDisplay(payoutCurrent_num);
	var whichIcon_1_num:Number = reel_1_icon_array[reelsCurrent_array[0] - 1];
	var whichIcon_2_num:Number = reel_2_icon_array[reelsCurrent_array[1] - 1];
	var whichIcon_3_num:Number = reel_3_icon_array[reelsCurrent_array[2] - 1];
	// ICON 1: Cherries
	if (whichIcon_1_num == 1) {
		payoutCurrent_num += payoutLevel_1_num * coinsPlayedCurrent_num;
		sparkle_1_mc.sparkle_flag_bool = true;
		if (whichIcon_2_num == 1) {
			payoutCurrent_num += (payoutLevel_2_num - payoutLevel_1_num) * coinsPlayedCurrent_num;
			sparkle_2_mc.sparkle_flag_bool = true;
			if (whichIcon_3_num == 1 || whichIcon_3_num == 5) {
				payoutCurrent_num += (payoutLevel_3_num - payoutLevel_2_num) * coinsPlayedCurrent_num;
				sparkle_3_mc.sparkle_flag_bool = true;
			}
		}
		// ICON 2: Orange                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	} else if (whichIcon_1_num == 2) {
		if (whichIcon_2_num == 2) {
			if (whichIcon_3_num == 2 || whichIcon_3_num == 5) {
				payoutCurrent_num = payoutLevel_4_num * coinsPlayedCurrent_num;
				sparkle_1_mc.sparkle_flag_bool = true;
				sparkle_2_mc.sparkle_flag_bool = true;
				sparkle_3_mc.sparkle_flag_bool = true;
			}
		}
		// ICON 3: Plum                                                                                                                                                                                                                                                                                                                                                                                                                                                       
	} else if (whichIcon_1_num == 3) {
		if (whichIcon_2_num == 3) {
			if (whichIcon_3_num == 3 || whichIcon_3_num == 5) {
				payoutCurrent_num = payoutLevel_5_num * coinsPlayedCurrent_num;
				sparkle_1_mc.sparkle_flag_bool = true;
				sparkle_2_mc.sparkle_flag_bool = true;
				sparkle_3_mc.sparkle_flag_bool = true;
			}
		}
		// ICON 4: Bell                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	} else if (whichIcon_1_num == 4) {
		if (whichIcon_2_num == 4) {
			if (whichIcon_3_num == 4 || whichIcon_3_num == 5) {
				payoutCurrent_num = payoutLevel_6_num * coinsPlayedCurrent_num;
				sparkle_1_mc.sparkle_flag_bool = true;
				sparkle_2_mc.sparkle_flag_bool = true;
				sparkle_3_mc.sparkle_flag_bool = true;
			}
		}
		// ICON 5: Bar                                                                                                                                                                                                                                                                                                                                                                                                                                                      
	} else if (whichIcon_1_num == 5) {
		if (whichIcon_2_num == 5) {
			if (whichIcon_3_num == 5) {
				payoutCurrent_num = payoutLevel_7_num * coinsPlayedCurrent_num;
				sparkle_1_mc.sparkle_flag_bool = true;
				sparkle_2_mc.sparkle_flag_bool = true;
				sparkle_3_mc.sparkle_flag_bool = true;
			}
		}
		// ICON 6: Seven
	} else if (whichIcon_1_num == 6) {
		if (whichIcon_2_num == 6) {
			if (whichIcon_3_num == 6) {
				payoutCurrent_num = payoutLevel_8_num * coinsPlayedCurrent_num;
				sparkle_1_mc.sparkle_flag_bool = true;
				sparkle_2_mc.sparkle_flag_bool = true;
				sparkle_3_mc.sparkle_flag_bool = true;
			}
		}
		// ICON 7: New Icon
	} else if (whichIcon_1_num == 7) {
		if (whichIcon_2_num == 7) {
			if (whichIcon_3_num == 7) {
				payoutCurrent_num = payoutLevel_9_num * coinsPlayedCurrent_num;
				sparkle_1_mc.sparkle_flag_bool = true;
				sparkle_2_mc.sparkle_flag_bool = true;
				sparkle_3_mc.sparkle_flag_bool = true;
			}
		}
	}
}


Change the Payout Table graphic
Because you've added a new icon, you'll need to add a new row into the Payout Table graphic. The new row will need to contain scaled down versions of your new icon as well as 3 new dynamic text boxes for each 'coin played' column. They must be named payout_9_1, payout_9_2 and payout_9_1

See the 'Changing the Payout Table graphic' section above for more details.



Changing payout amounts for each winning spin
----------------------------------------------------------------------
- open the .FLA in Flash
- in the Main Timeline, double-click on the 'slot_machine_mc' MovieClip (on the 'slot_machine' Layer)
- single-click on Frame 3 (labelled 'functions') of the 'Actions' Layer and open your Actions window
- on lines 87 through 94 you'll see:

var payoutLevel_1_num:Number = 2;
var payoutLevel_2_num:Number = 5;
var payoutLevel_3_num:Number = 10;
var payoutLevel_4_num:Number = 12;
var payoutLevel_5_num:Number = 20;
var payoutLevel_6_num:Number = 50;
var payoutLevel_7_num:Number = 100;
var payoutLevel_8_num:Number = 250;

…these variable values correspond to the winning spins (from most likely to least likely):

Cherry----------[any]----------[any]
Cherry----------Cherry---------[any]
Cherry----------Cherry---------Cherry/Bar
Orange----------Orange---------Orange/Bar
Plum------------Plum-----------Plum/Bar
Bell------------Bell-----------Bell/Bar
Bar-------------Bar------------Bar
7---------------7--------------7

…if 2 coins are played, the payout is doubled and if 3 coins are played, the payout is tripled.



Changing the payout percentage for the machine
----------------------------------------------------------------------
The programming behind this file is based on how modern, computerized slot machines function. Before the late 1970s, a mechanical slot machine's spin results were based on the numerical distribution of icons on its reels. Back then, the only way for the casinos to profitably offer larger slot machine jackpots was to decrease the odds by adding more icons to the reels or adding more reels.

There was a physical limit to the number of icons that could fit on each reel. In the late 1970s, a computerized 'virtual reel' system was developed by Bally so that an almost unlimited number of icons could be added to the reels without having to worry about running out of room.

The 'virtual reels' contained numbers which corresponded to all of the possible spin outcomes, with more numbers being assigned to losing results. A random number generator program would cycle through all of the numbers and generate 3 at random when a coin was dropped into the machine - this determined where the reels would stop. The odds of winning spins and jackpots could be controlled precisely because of the reels' virtual nature.

In Flash, arrays and a random number generator can be used to approximate this system. On lines 134 through 137 of Frame 3 of the Main Timeline, you can see the array used to store the icon weightings:

// REEL ICON POSITION WEIGHTS
var reel_1_virtual_array:Array = new Array(1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 4, 5, 5, 6, 6, 6, 6, 6);
var reel_2_virtual_array:Array = new Array(1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 6);
var reel_3_virtual_array:Array = new Array(1, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 5, 5, 5, 5, 5, 5, 6);

To calculate the payout percentage for this machine, count the instances of each icon on each reel:

---------------------REEL:
---------------------1------2-----3

7--------------------2------3-----1
Bar------------------3-----11-----1
Bells---------------12------4-----1
Plums----------------8------2-----9
Oranges--------------2------6----14
Cherries-------------5------6-----6

TOTAL---------------32-----32----32


So if my math is correct (and it could be way off - feel free to let me know), the total possible number of spin outcomes is 32 * 32 *32 or 32,768 and the frequency of winning spins is:

7----------7---------7           happens 2  * 3  * 1      = 6    times
Bar--------Bar-------Bar         happens 3  * 11 * 1      = 33   times
Bell-------Bell------Bell/Bar    happens 12 * 4  * (1+1)  = 96   times
Plum-------Plum------Plum/Bar    happens 8  * 2  * (9+1)  = 160  times
Orange-----Orange----Orange/Bar  happens 2  * 6  * (14+1) = 180  times
Cherry-----Cherry----Cherry/Bar  happens 5  * 6  * (6+1)  = 210  times
Cherry-----Cherry----[any]       happens 5  * 6  * 26     = 780  times
Cherry-----[any]-----[any]       happens 5  * 26 * 32     = 4160 times

So if the payouts are:

7----------7---------7           250
Bar--------Bar-------Bar         100
Bell-------Bell------Bell/Bar    50
Plum-------Plum------Plum/Bar    20
Orange-----Orange----Orange/Bar  12
Cherry-----Cherry----Cherry/Bar  10
Cherry-----Cherry----[any]       5
Cherry-----[any]-----[any]       2

The total payout on 32,768 spins would be:

6    x   250   =   1500
33   x   100   =   3300
96   x   50    =   4800
160  x   20    =   3200
180  x   12    =   2160
210  x   10    =   2100
780  x   5     =   3900
4160 x   2     =   8320
               ----------
                   29,280

And the payout percentage would be:

(29,280  ÷  32,768) * 100  =  89.355 %

So in theory if you spun the reels 32,768 times, you would see a return of 89.355% of the coins you put in. By adjusting the reel weightings arrays on lines 134 through 137 of Frame 3 of the Main Timeline along with the payout variables on lines 87 through 94, you can increase or decrease the payout percentage for this machine.






----------------------------------------------------------------------
Modifying the XML file:
----------------------------------------------------------------------
By adjusting the values within the XML file, you can change the way the .SWF plays back. Make sure all of the tags are properly closed and that the values within the <globals> tag are all enclosed in quote marks. One missing tag or character and the .SWF will not work properly.

The location of the XML config file is passed as a variable (config_file) by the index.html file. To adjust this variable, open the index.html file and look for this line:

	var flashvars = {
		config_file: "slot_machine_config.xml"
	};

	- change "slot_machine_config.xml" to your new path
	- for example, an absolute path such as "http://www.yoursite.com/xml/slot_machine_config.xml"


Alternately, if the config_file variable is not passed from the index.html file, the .SWF  is programmed to load the XML file located in the same folder. To change the path to the XML file:

	- open the .FLA in Flash
	- in the Main Timeline, double-click on the 'slot_machine_mc' MovieClip (on the 'slot_machine' Layer)
	- single-click on Frame 2 of the 'Actions' Layer and open your Actions window
	- find this line of code:

	// --------------------------------------------------
	// LOAD XML
	// --------------------------------------------------
	if (_level0.config_file) {
		var config_str:String = _level0.config_file;
	} else {
		var config_str:String = "slot_machine_config.xml";
	}
	data_xml.load(config_str);

	- change "slot_machine_config.xml" to your new path
	- for example, an absolute path such as "http://www.yoursite.com/xml/slot_machine_config.xml"




resetColourOff="0x505a64"
----------------------------------------------------------------------
Reset button off state Hex color

resetColourUp="0x008CE6"
----------------------------------------------------------------------
Reset button up state Hex color

resetColourOver="0x33CCFF"
----------------------------------------------------------------------
Reset button over state Hex color




betColourOff="0x5a3c32"
----------------------------------------------------------------------
Bet button off state Hex color

betColourUp="0xCC0000"
----------------------------------------------------------------------
Bet button up state Hex color

betColourOver="0xFF5033" 
----------------------------------------------------------------------
Bet button over state Hex color




betmaxColourOff="0x5a3c32"
----------------------------------------------------------------------
Bet Max button off state Hex color

betmaxColourUp="0xCC0000"
----------------------------------------------------------------------
Bet Max button up state Hex color

betmaxColourOver="0xFF5033"
----------------------------------------------------------------------
Bet Max button over state Hex color




paytableColourOff="0x505a50"
----------------------------------------------------------------------
Payout Table button off state Hex color

paytableColourUp="0x00CC00"
----------------------------------------------------------------------
Payout Tablebutton up state Hex color

paytableColourOver="0x99FF00"
----------------------------------------------------------------------
Payout Table button over state Hex color




spinColourOff="0x505a50"
----------------------------------------------------------------------
Spin button off state Hex color

spinColourUp="0x00CC00"
----------------------------------------------------------------------
Spin button up state Hex color

spinColourOver="0x99FF00"
----------------------------------------------------------------------
Spin button over state Hex color




numberColorOn="0xff3300"
----------------------------------------------------------------------
Controls the Hex color of the digital score numbers. For example, with numberColorOn="0xff3300", the numbers would be a bright red.


numberColorOff="0x330000"
----------------------------------------------------------------------
Controls the Hex color of the 'unlit' areas of the digital score numbers. For example, with numberColorOff="0x330000", the 'unlit' areas would be a dark red.


windowBgColor="0x141414"
----------------------------------------------------------------------
Controls the Hex color of the digital score number background. For example, with windowBgColor="0x141414", the background of digital score numbers would be a dark grey.


windowHiliteAlpha="40"
----------------------------------------------------------------------
Controls the Alpha value (0 to 100) of the highlight on the digital score numbers.


windowShadowAlpha="25"
----------------------------------------------------------------------
Controls the Alpha value (0 to 100) of the shadow on the digital score numbers.




soundFXon="true"
----------------------------------------------------------------------
set to "true": sound effect plays each time a number flips into final position
set to "false": sound effects off


spinSoundVolume="35"
----------------------------------------------------------------------
Volume level percentage (0 to 100 %) of reels spinning sound effect


stopSoundVolume="35"
----------------------------------------------------------------------
Volume level percentage (0 to 100 %) of reels stop sound effect


coinSoundVolume="60"
----------------------------------------------------------------------
Volume level percentage (0 to 100 %) of coin drop sound effect


handleSoundVolume="50"
----------------------------------------------------------------------
Volume level percentage (0 to 100 %) of handle pull sound effect


winnerSoundVolume="40"
----------------------------------------------------------------------
Volume level percentage (0 to 100 %) of winner loop sound effect






-----------------------------------------------------------------


Tweener License <http://code.google.com/p/tweener/wiki/License>
Tweener is free open source software, licensed under the MIT License <http://en.wikipedia.org/wiki/MIT_License>. Tweener also makes use of Robert Penner's easing equations <http://www.robertpenner.com/easing/>, which is also free open source software, licensed under the BSD License <http://www.opensource.org/licenses/bsd-license.php>.


SWFObject License
SWFObject v2.0 <http://code.google.com/p/swfobject/>
Copyright (c) 2007 Geoff Stearns, Michael Williams, and Bobby van der Sluis
This software is released under the MIT License <http://www.opensource.org/licenses/mit-license.php>


-----------------------------------------------------------------






If you have any ideas on how to make this thing work better/more efficiently, feel free to contact me…

Daniel Sadowski.

-----------------------------------------------------------------
© biteMedia, 2008
-----------------------------------------------------------------
biteMedia
http://www.bitemedia.com
-----------------------------------------------------------------
(416) 787-1808
-----------------------------------------------------------------
