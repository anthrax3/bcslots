this._visible = false;

import flash.external.ExternalInterface;
import flash.filters.BlurFilter;
import caurina.transitions.Tweener;
import de.polygonal.math.PM_PRNG;
import flash.geom.ColorTransform;
import flash.geom.Transform;
 
//unchanging stuff
var speedMax_num:Number = Number(data_xml.childNodes[0].attributes.speedMax);
if (data_xml.childNodes[0].attributes.soundFXon == "true") {
  var soundFXon_bool:Boolean = true;
} else {
  var soundFXon_bool:Boolean = false;
}
var spinSoundVolume_num:Number = Number(data_xml.childNodes[0].attributes.spinSoundVolume);
var stopSoundVolume_num:Number = Number(data_xml.childNodes[0].attributes.stopSoundVolume);
var coinSoundVolume_num:Number = Number(data_xml.childNodes[0].attributes.coinSoundVolume);
var handleSoundVolume_num:Number = Number(data_xml.childNodes[0].attributes.handleSoundVolume);
var winnerSoundVolume_num:Number = Number(data_xml.childNodes[0].attributes.winnerSoundVolume);
var reset_colour_off:Number = Number(data_xml.childNodes[0].attributes.resetColourOff);
var reset_colour_up:Number = Number(data_xml.childNodes[0].attributes.resetColourUp);
var reset_colour_over:Number = Number(data_xml.childNodes[0].attributes.resetColourOver);
var bet_colour_off:Number = Number(data_xml.childNodes[0].attributes.betColourOff);
var bet_colour_up:Number = Number(data_xml.childNodes[0].attributes.betColourUp);
var bet_colour_over:Number = Number(data_xml.childNodes[0].attributes.betColourOver);
var betmax_colour_off:Number = Number(data_xml.childNodes[0].attributes.betmaxColourOff);
var betmax_colour_up:Number = Number(data_xml.childNodes[0].attributes.betmaxColourUp);
var betmax_colour_over:Number = Number(data_xml.childNodes[0].attributes.betmaxColourOver);
var changevalue_colour_off:Number = Number(data_xml.childNodes[0].attributes.changevalueColourOff);
var changevalue_colour_up:Number = Number(data_xml.childNodes[0].attributes.changevalueColourUp);
var changevalue_colour_over:Number = Number(data_xml.childNodes[0].attributes.changevalueColourOver);
var paytable_colour_off:Number = Number(data_xml.childNodes[0].attributes.paytableColourOff);
var paytable_colour_up:Number = Number(data_xml.childNodes[0].attributes.paytableColourUp);
var paytable_colour_over:Number = Number(data_xml.childNodes[0].attributes.paytableColourOver);
var spin_colour_off:Number = Number(data_xml.childNodes[0].attributes.spinColourOff);
var spin_colour_up:Number = Number(data_xml.childNodes[0].attributes.spinColourUp);
var spin_colour_over:Number = Number(data_xml.childNodes[0].attributes.spinColourOver);
var number_colour_on:Number = data_xml.childNodes[0].attributes.numberColorOn;
var number_colour_off:Number = data_xml.childNodes[0].attributes.numberColorOff;
var window_bg_color:Number = data_xml.childNodes[0].attributes.windowBgColor;
var window_hilite_alpha:Number = Number(data_xml.childNodes[0].attributes.windowHiliteAlpha);
var window_shadow_alpha:Number = Number(data_xml.childNodes[0].attributes.windowShadowAlpha);
var payoutLevel_1_num:Number = 2;
var payoutLevel_2_num:Number = 5;
var payoutLevel_3_num:Number = 10;
var payoutLevel_4_num:Number = 12;
var payoutLevel_5_num:Number = 20;
var payoutLevel_6_num:Number = 50;
var payoutLevel_7_num:Number = 100;
var payoutLevel_8_num:Number = 250;
var payoutLevels_num:Number = 8;

frameLabel_str = "functions";
stopped_bool = false;
//
var reelsMax_num:Number = 3;
var iconHeight_num:Number = 60;
var iconWidth_num:Number = 90;
var speedMin_num:Number = 0;
var speedMax_num:Number = 30;

var spinSoundLoop_num:Number = 100;

//
var moneyInit_num:Number = 100;
var moneyReset_num:Number = moneyInit_num;
var moneyCurrent_num:Number = moneyInit_num;
var payoutCurrent_num:Number = 0;
var payoutDisplay_num:Number = payoutCurrent_num;
var coinsPlayedCurrent_num:Number = 0;
var coinsPlayedMax_num:Number = 3;

var balance_before_payout:Number = 0;
var balance:Number = 0;

var balance_in_dBTC:Number = Number(ExternalInterface.call("balance_in_dBTC"));
var balance_in_cBTC:Number = Number(ExternalInterface.call("balance_in_cBTC"));
var balance_in_mBTC:Number = Number(ExternalInterface.call("balance_in_mBTC"));
var credit_value:String = "0.001";

//
for (var i:Number = 1; i <= reelsMax_num; i++) {
  this["sparkle_" + i + "_mc"]["sparkle_flag_bool"] = false;
}
// --------------------------------------------------
// SHARED OBJECT COOKIE
// --------------------------------------------------
var cookie_so:SharedObject = SharedObject.getLocal("biscuit");
//
if (cookie_so.data.moneySO_num == undefined) {
  cookie_so.data.moneySO_num = moneyInit_num;
  cookie_so.flush();
} else {
  if (cookie_so.data.moneySO_num > 0) {
    moneyInit_num = cookie_so.data.moneySO_num;
  }
}
// --------------------------------------------------
// ARRAYS
// --------------------------------------------------
var reelsCurrent_array:Array = new Array(1, 1, 1);
// REEL ICON VALUES
var reel_1_icon_array:Array = new Array(6, 4, 3, 5, 2, 1);
var reel_2_icon_array:Array = new Array(6, 4, 5, 3, 2, 1);
var reel_3_icon_array:Array = new Array(6, 3, 2, 4, 1, 5);
var tileIcons_num:Number = reel_1_icon_array.length;
var revolutionYmove_num:Number = tileIcons_num * iconHeight_num;
// --------------------------------------------------
// SOUND FX
// --------------------------------------------------
if (soundFXon_bool == true) {
  var slot_spin_sound:Sound = new Sound(skinComp_mc);
  slot_spin_sound.attachSound("slot_spin");
  slot_spin_sound.setVolume(spinSoundVolume_num);
  //
  var slot_handle_sound:Sound = new Sound(spinButton_mc);
  slot_handle_sound.attachSound("slot_handle");
  slot_handle_sound.setVolume(handleSoundVolume_num);
  //
  var slot_coin_sound:Sound = new Sound(betButton_mc);
  slot_coin_sound.attachSound("slot_coin");
  slot_coin_sound.setVolume(coinSoundVolume_num);
}
// --------------------------------------------------                                                                                                                                                                                                                                                                                          
// BUTTONS
// --------------------------------------------------
// RESET BUTTON
Tweener.addTween(resetButton_mc.colour_mc,{_color:reset_colour_off, time:0, transition:buttonFadeAnim_str});
// PAY TABLE BUTTON
var paytable_pressed_bool:Boolean = false;
Tweener.addTween(payTableButton_mc.colour_mc,{_color:paytable_colour_up, time:0, transition:buttonFadeAnim_str});
// BET BUTTON
Tweener.addTween(betButton_mc.colour_mc,{_color:bet_colour_up, time:0, transition:buttonFadeAnim_str});
// BET MAX BUTTON
var betmax_pressed_bool:Boolean = false;
Tweener.addTween(betMaxButton_mc.colour_mc,{_color:betmax_colour_up, time:0, transition:buttonFadeAnim_str});
Tweener.addTween(changeValueButton_mc.colour_mc,{_color:changevalue_colour_up, time:0, transition:buttonFadeAnim_str});
// SPIN BUTTON
Tweener.addTween(spinButton_mc.colour_mc,{_color:spin_colour_off, time:0, transition:buttonFadeAnim_str});
//
var buttonDisableFadeTime_num:Number = 0.5;
var buttonEnableFadeTime_num:Number = 0.5;
var buttonRolloverFadeTime_num:Number = 0.1;
var buttonRollOutFadeTime_num:Number = 0.1;
var buttonFadeAnim_str:String = "linear";
// --------------------------------------------------          
// BITMAP CACHING
// --------------------------------------------------
resetButton_mc.cacheAsBitmap = true;
payTableButton_mc.cacheAsBitmap = true;
betButton_mc.cacheAsBitmap = true;
changeValueButton_mc.cacheAsBitmap = true;
betMaxButton_mc.cacheAsBitmap = true;
spinButton_mc.cacheAsBitmap = true;
skinComp_mc.cacheAsBitmap = true;
// --------------------------------------------------
// INIT DISPLAY FUNCTION
// --------------------------------------------------
function fncInitDisplay():Void {
  for (var i:Number = 1; i <= reelsMax_num; i++) {
    // DUPLICATE REEL ICONS
    var parentClip_mc = eval("reel_" + i + "_mc.reelTile_mc");
    parentClip_mc.createEmptyMovieClip("iconShell_mc",i);
    var whichIconIndex_num:Number = 0;
    var iconsMax_num:Number = 3 + this["reel_" + i + "_icon_array"].length * 2;
    //
    for (var j:Number = 1; j <= iconsMax_num; j++) {
      if (j < iconsMax_num) {
        parentClip_mc.iconShell_mc.attachMovie("reel_icon_" + this["reel_" + i + "_icon_array"][whichIconIndex_num],"icon_" + j + "_mc",j);
        parentClip_mc.iconShell_mc["icon_" + j + "_mc"]._y = -1 * ((iconHeight_num * (j - 1)) - (iconHeight_num / 2));
      } else {
        parentClip_mc.iconShell_mc.attachMovie("reel_icon_" + this["reel_" + i + "_icon_array"][this["reel_" + i + "_icon_array"].length - 1],"icon_" + j + "_mc",j);
        parentClip_mc.iconShell_mc["icon_" + j + "_mc"]._y = iconHeight_num * 1.5;
      }
      parentClip_mc.iconShell_mc["icon_" + j + "_mc"]._x = iconWidth_num / 2;
      // 
      if (whichIconIndex_num < this["reel_" + i + "_icon_array"].length - 1) {
        whichIconIndex_num++;
      } else {
        whichIconIndex_num = 0;
      }
    }
    // VARIABLES
    this["reel_" + i + "_mc"]["reelTile_mc"].whichReel_num = i;
    this["reel_" + i + "_mc"]["reelTile_mc"].reelPosCurrent_num = 1;
    this["reel_" + i + "_mc"]["reelTile_mc"].reelPosNew_num = undefined;
    //
    this["reel_" + i + "_mc"]["reelTile_mc"].speedCurrent_num = speedMin_num;
    this["reel_" + i + "_mc"]["reelTile_mc"].yPosStart_num = this["reel_" + i + "_mc"]["reelTile_mc"]._y;
    this["reel_" + i + "_mc"]["reelTile_mc"].yPosEnd_num = this.yPosStart_num + revolutionYmove_num;
    this["reel_" + i + "_mc"]["reelTile_mc"].yPosCurrent_num = this.yPosStart_num;
    this["reel_" + i + "_mc"]["reelTile_mc"].stopflag_bool = false;
    //
    this["reel_" + i + "_mc"]["windowComp_mc"].cacheAsBitmap = true;
    this["reel_" + i + "_mc"]["windowComp_mc"].cacheAsBitmap = true;
    this["reel_" + i + "_mc"]["windowComp_mc"].cacheAsBitmap = true;
    // BLUR
    var blurX:Number = 0;
    var blurY:Number = 0;
    var quality:Number = 1;
    var filter:BlurFilter = new BlurFilter(blurX, blurY, quality);
    var filterArray:Array = new Array();
    filterArray.push(filter);
    this["reel_" + i + "_mc"]["reelTile_mc"].filters = filterArray;
  }
  // BUTTONS
  fncButtonEnable(payTableButton_mc,paytable_colour_up);
  fncButtonEnable(betButton_mc,bet_colour_up);
  fncButtonEnable(changeValueButton_mc,changevalue_colour_up);
  fncButtonEnable(betMaxButton_mc,betmax_colour_up);
  skinComp_mc.seal_dBTC._visible = false;
  skinComp_mc.seal_cBTC._visible = false;
  skinComp_mc.seal_mBTC._visible = false;
}
// --------------------------------------------------
// SPIN FUNCTIONS
// --------------------------------------------------
fncSpinReel = function (whichReel:Number):Void {
  this["reel_" + whichReel + "_mc"]["reelTile_mc"].speedCurrent_num = speedMin_num;
  this["reel_" + whichReel + "_mc"]["reelTile_mc"].yPosStart_num = this["reel_" + whichReel + "_mc"]["reelTile_mc"]._y;
  this["reel_" + whichReel + "_mc"]["reelTile_mc"].yPosEnd_num = revolutionYmove_num + (iconHeight_num * (this["reel_" + whichReel + "_mc"]["reelTile_mc"].reelPosNew_num - 1));
  this["reel_" + whichReel + "_mc"]["reelTile_mc"].yPosCurrent_num = this["reel_" + whichReel + "_mc"]["reelTile_mc"].yPosStart_num;
  this["reel_" + whichReel + "_mc"]["reelTile_mc"].stopflag_bool = false;
  // MOVE ACCLERATE
  this["reel_" + whichReel + "_mc"]["reelTile_mc"].speedCurrent_num = Tweener.addTween(this["reel_" + whichReel + "_mc"]["reelTile_mc"], {speedCurrent_num:speedMax_num, transition:"easeInQuad", _blur_blurX:0, _blur_blurY:8, time:1.0});
  //
  this["reel_" + whichReel + "_mc"]["reelTile_mc"].onEnterFrame = function() {
    if (this._y < revolutionYmove_num - this.speedCurrent_num) {
      this._y += this.speedCurrent_num;
      this.yPosCurrent_num = this._y;
    } else {
      if (this.stopflag_bool == true) {
        delete this.onEnterFrame;
        this.speedCurrent_num = 0;
        this._y = 0;
        // MOVE DECCLERATE
        Tweener.addTween(this,{_y:this.yPosEnd_num + 3, _blur_blurX:0, _blur_blurY:0, time:0.80 + (this.reelPosNew_num * 0.05), transition:"easeOutSine", onComplete:fncEndSpin, onCompleteParams:[whichReel]});
      } else {
        this._y = 0;
      }
    }
  };
};
fncStopReel = function (whichReel:Number):Void {
  var reel_target:MovieClip = eval("reel_" + whichReel + "_mc.reelTile_mc");
  reel_target.stopflag_bool = true;
};
fncEndSpin = function (whichReel:Number):Void {
  var reel_target:MovieClip = eval("reel_" + whichReel + "_mc.reelTile_mc");
  // REMOVE TWEENS
  Tweener.removeTweens(eval("reel_" + whichReel + "_mc.reelTile_mc"));
  reel_target._y = iconHeight_num * (reel_target.reelPosNew_num - 1);
  reel_target.yPosStart_num = iconHeight_num * reel_target.reelPosNew_num;
  reel_target.reelPosCurrent_num = reel_target.reelPosNew_num;
  reel_target.reelPosNew_num = undefined;
  // SOUND FX: Stop
  if (soundFXon_bool == true) {
    this["slot_stop_sound_" + whichReel] = new Sound(eval("reel_" + whichReel + "_mc.reelTile_mc"));
    this["slot_stop_sound_" + whichReel].attachSound("slot_stop");
    this["slot_stop_sound_" + whichReel].setVolume(stopSoundVolume_num);
    this["slot_stop_sound_" + whichReel].start(0,1);
    delete this["slot_stop_sound_" + whichReel];
    // SOUND FX: Spin
    if (whichReel == reelsMax_num) {
      slot_spin_sound.stop("slot_spin");
    }
  }
  if (whichReel < reelsMax_num) {
    fncStopReel(whichReel + 1);
  } else {
    // PAYOUT
    fncUpdateMoneyDisplay();
  }
};
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
  }
}
// --------------------------------------------------
// PAYOUT DISPLAY FUNCTIONS
// --------------------------------------------------
function fncSetMoneyDisplay(number:Number):Void {
  money_counter_mc.startNumber = number;
  money_counter_mc.fncInitNumberPos();
  moneyCurrent_num = number;
  // SHARED OBJECT
  cookie_so.data.moneySO_num = moneyCurrent_num;
  cookie_so.flush();
}
function fncUpdateMoneyDisplay():Void {
  if (payoutCurrent_num > 0) {
    money_counter_mc.startNumber = moneyCurrent_num;
    payoutDisplay_num = payoutCurrent_num;
    fncSetPayoutDisplay(payoutCurrent_num);
    moneyCurrent_num = balance;
//    moneyCurrent_num += payoutCurrent_num;
    money_counter_mc.endNumber = moneyCurrent_num;
    money_counter_mc.fncInitNumberValues();
    money_counter_mc.fncInitInterval();
    //
    for (var i:Number = 1; i <= reelsMax_num; i++) {
      if (this["sparkle_" + i + "_mc"]["sparkle_flag_bool"] == true) {
        this["sparkle_" + i + "_mc"].gotoAndPlay("playing");
      }
    }
  } else {
    if (moneyCurrent_num > 0) {
      fncButtonEnable(payTableButton_mc,paytable_colour_up);
      fncButtonEnable(betButton_mc,bet_colour_up);
      fncButtonEnable(changeValueButton_mc,changevalue_colour_up);
      fncButtonEnable(betMaxButton_mc,betmax_colour_up);
      fncButtonEnable(spinButton_mc, spin_colour_up);
      fncUpdateBetAmountWhenCreditsTooLow();
    }
    else if (balance_in_cBTC > 0)
    {
      fncChangeValueTo("0.01");
      fncButtonEnable(payTableButton_mc,paytable_colour_up);
      fncButtonEnable(betButton_mc,bet_colour_up);
      fncButtonEnable(changeValueButton_mc,changevalue_colour_up);
      fncButtonEnable(betMaxButton_mc,betmax_colour_up);
      fncButtonEnable(spinButton_mc, spin_colour_up);
      fncUpdateBetAmountWhenCreditsTooLow();

    }
    else if (balance_in_mBTC > 0)
    {
      fncChangeValue("0.001");
      fncButtonEnable(payTableButton_mc,paytable_colour_up);
      fncButtonEnable(betButton_mc,bet_colour_up);
      fncButtonEnable(changeValueButton_mc,changevalue_colour_up);
      fncButtonEnable(betMaxButton_mc,betmax_colour_up);
      fncButtonEnable(spinButton_mc,spin_colour_up);
      fncUpdateBetAmountWhenCreditsTooLow()
    }
    else
    {
      fncButtonEnable(resetButton_mc,reset_colour_up);
    }
  }
  // SHARED OBJECT
  //cookie_so.data.moneySO_num = moneyCurrent_num;
  //cookie_so.flush();
}

function fncUpdateBetAmountWhenCreditsTooLow():Void {
  ExternalInterface.call("console.log", "hiz");
  if (moneyCurrent_num == 2 && coinsPlayedCurrent > moneyCurrent_num)
  {
    coinsPlayedCurrent_num = 2;
    fncSetCoinsDisplay(coinsPlayedCurrent_num);
  }
  if (moneyCurrent_num == 1 && coinsPlayedCurrent > moneyCurrent_num)
  {
    coinsPlayedCurrent_num = 1;
    fncSetCoinsDisplay(coinsPlayedCurrent_num);
  }
}
function fncSetPayoutDisplay(number:Number):Void {
  payout_counter_mc.startNumber = number;
  payout_counter_mc.fncInitNumberPos();
}
function fncSetCoinsDisplay(number:Number):Void {
  coins_played_mc.startNumber = number;
  coins_played_mc.fncInitNumberPos();
}
// **************************************************
// BUTTONS
// **************************************************
fncButtonDisable = function (whichButton, colorOff):Void {
  if (whichButton.enabled != false) {
    whichButton.enabled = false;
    Tweener.removeTweens(whichButton.colour_mc,"_color");
    Tweener.addTween(whichButton.colour_mc,{_color:colorOff, time:buttonDisableFadeTime_num, transition:buttonFadeAnim_str});
  }
  if (whichButton.useHandCursor != false) {
    whichButton.useHandCursor = false;
  }
};
fncButtonEnable = function (whichButton, colorUp):Void {
  if (whichButton.enabled != true) {
    whichButton.enabled = true;
    Tweener.removeTweens(whichButton.colour_mc,"_color");
    Tweener.addTween(whichButton.colour_mc,{_color:colorUp, time:buttonDisableFadeTime_num, transition:buttonFadeAnim_str});
  }
  if (whichButton.useHandCursor != true) {
    whichButton.useHandCursor = true;
  }
};
fncButtonRoll = function (whichButton, whichColor):Void {
  Tweener.removeTweens(whichButton,"_color");
  Tweener.addTween(whichButton.colour_mc,{_color:whichColor, time:buttonRolloverFadeTime_num, transition:buttonFadeAnim_str});
};
// --------------------------------------------------
// SPIN BUTTON
// --------------------------------------------------
spinButton_mc.onRollOver = function():Void  {
  fncButtonRoll(this,spin_colour_over);
};
spinButton_mc.onPress = function():Void  {
  //
};
spinButton_mc.onRelease = function():Void { 
  var xml:XML = new XML();
  var postParams:LoadVars = new LoadVars();
  ExternalInterface.call("console.log", postParams.id);
  postParams.id = ExternalInterface.call("getIdFromCookie");
  postParams.credits = coinsPlayedCurrent_num;
  postParams.credit_value = credit_value;
  var that = this;
  xml.onLoad = function(success:Boolean){
    ExternalInterface.call("console.log", success);
    if (success) {
      ExternalInterface.call("console.log", success);
      ExternalInterface.call("console.log", xml.toString());
      var firstValue:Number = fnXMLToNumberValue(xml, 1);
      var secondValue:Number = fnXMLToNumberValue(xml, 2);
      var thirdValue:Number = fnXMLToNumberValue(xml, 3);
      var values:Array = new Array(firstValue, secondValue, thirdValue);
      balance_in_dBTC = xml.childNodes[1].attributes.balance_in_dBTC;
      balance_in_cBTC = xml.childNodes[1].attributes.balance_in_cBTC;
      balance_in_mBTC = xml.childNodes[1].attributes.balance_in_mBTC;
      if (credit_value === "0.1")
      {
        balance = xml.childNodes[1].attributes.balance_in_dBTC;
        balance_before_spin = xml.childNodes[1].attributes.balance_before_payout_in_dBTC;
      }
      else if (credit_value === "0.01")
      {
        balance = xml.childNodes[1].attributes.balance_in_cBTC;
        balance_before_spin = xml.childNodes[1].attributes.balance_before_payout_in_cBTC;
      }
      else if (credit_value === "0.001")
      {
        balance = xml.childNodes[1].attributes.balance_in_mBTC;
        balance_before_spin = xml.childNodes[1].attributes.balance_before_payout_in_mBTC;
      }
      else
      {
        throw 'invalid credit amount';
      }
      fnOnSpin(that, values);
    }
    else {
      stopAllSounds();
      gotoAndPlay("cantConnect");
    }
  }
  postParams.sendAndLoad("/spin.xml", xml, 'POST');
};

fnXMLToNumberValue = function(xml:XML, reelPosition:Number):Number {
  var iconArray = null;
  switch(reelPosition) {
    case 1:
      iconArray = reel_1_icon_array;
      break;
    case 2:
      iconArray = reel_2_icon_array;
      break;
    case 3:
      iconArray = reel_3_icon_array;
      break;
    default:
      throw 'invalid reel position';
      break;
  }
  var namedValue = fnXMLToReelNamedValue(xml, reelPosition);
  var numberValue = fnNamedValueToNumberValue(namedValue, iconArray);
  return numberValue;
}

fnXMLToReelNamedValue = function(xml:XML, reelPosition:Number):String {
  if (reelPosition === 1)
  {
    return xml.childNodes[1].attributes.reel1;
  }
  else if (reelPosition === 2)
  {
    return xml.childNodes[1].attributes.reel2;
  }
  else if (reelPosition === 3)
  {
    return xml.childNodes[1].attributes.reel3;
  }
  else
  {
    throw 'invalid reel position';
  }
}

fnNamedValueToNumberValue = function(namedValue:String, iconArray:Array):Number {
  for (i:Number = 0; i < iconArray.length; i++) {
    var iconValue = iconArray[i];
    if (namedValue === "cherries" && iconValue === 1)
    {
      return i + 1;
    }
    else if (namedValue === "orange" && iconValue === 2)
    {
      return i + 1;
    }
    else if (namedValue === "plum" && iconValue === 3)
    {
      return i + 1;
    }
    else if (namedValue === "bell" && iconValue === 4)
    {
      return i + 1;
    }
    else if (namedValue === "bar" && iconValue === 5)
    {
      return i + 1;
    }
    else if (namedValue === "seven" && iconValue === 6)
    {
      return i + 1;
    }
  }
  throw "value not matched";
}



fnOnSpin = function(that, values):Void  {
  fncButtonDisable(payTableButton_mc,paytable_colour_off);
  fncButtonDisable(changeValueButton_mc,changevalue_colour_off);
  fncButtonDisable(betButton_mc,bet_colour_off);
  fncButtonDisable(betMaxButton_mc,betmax_colour_off);
  fncButtonDisable(spinButton_mc,spin_colour_off);
  
  //
  if (moneyCurrent_num > 0) {
    // UPDATE MONEY
    if (coinsPlayedCurrent_num > moneyCurrent_num) {
      coinsPlayedCurrent_num = moneyCurrent_num;
      fncSetCoinsDisplay(coinsPlayedCurrent_num);
    }
    // SOUND FX                                                                                                                                                                                                                                                                            
    if (soundFXon_bool == true) {
      if (betmax_pressed_bool == false) {
        slot_handle_sound.start(0,1);
      } else {
        betmax_pressed_bool = false;
      }
      slot_spin_sound.start(0,spinSoundLoop_num);
    }
    moneyCurrent_num = balance_before_spin;
    fncSetMoneyDisplay(moneyCurrent_num);
    // RANDOM NUMBERS 
    var pr:PM_PRNG = new PM_PRNG();
    pr.seed = (Math.random() * 2147483646);
    // LOOP
    
    for (var i:Number = 1; i <= reelsMax_num; i++) {
      var reel_target:MovieClip = that._parent["reel_" + i + "_mc"]["reelTile_mc"];
      reel_target.reelPosNew_num = values[i - 1];
//      var pr_num:Number = Math.round(pr.nextInt() % divisor_num);
//      if (pr_num < 1) {
//        pr_num = 1;
//      }
//      if (pr_num > divisor_num - 1) {
//        pr_num = divisor_num - 1;
//      }
//      reel_target.reelPosNew_num = this._parent["reel_" + i + "_virtual_array"][pr_num];
      // ARRAY                                                                                        
      reelsCurrent_array[i - 1] = values[i - 1];
      // SPIN
      //import flash.external.ExternalInterface;
      //ExternalInterface.call( "console.log" , "before spin " + i.toString())
      fncSpinReel(i);
    }
    fncCheckPayout();
    Tweener.addTween(this,{time:1.5, onComplete:fncStopReel, onCompleteParams:[1]});

  }
};
spinButton_mc.onRollOut = function():Void  {
  fncButtonRoll(this,spin_colour_up);
};
spinButton_mc.onDragOut = function():Void  {
  this.onRollOut();
};
spinButton_mc.onReleaseOutside = function():Void  {
  this.onRollOut();
};

function fncChangeValueTo(bet_value:String):Void {
  if (bet_value === "0.1" && balance_in_cBTC > 0)
  {
    credit_value = "0.01";
    skinComp_mc.seal_dBTC._visible = false;
    skinComp_mc.seal_cBTC._visible = true;
    skinComp_mc.seal_mBTC._visible = false;
    fncSetMoneyDisplay(balance_in_cBTC);
  }
  else if (bet_value === "0.1" && balance_in_mBTC > 0)
  {
    credit_value = "0.001";
    skinComp_mc.seal_dBTC._visible = false;
    skinComp_mc.seal_cBTC._visible = false;
    skinComp_mc.seal_mBTC._visible = true;
    fncSetMoneyDisplay(balance_in_mBTC);
  }
  else if (bet_value=== "0.01")
  {
    credit_value = "0.001";
    skinComp_mc.seal_dBTC._visible = false;
    skinComp_mc.seal_cBTC._visible = false;
    skinComp_mc.seal_mBTC._visible = true;
    fncSetMoneyDisplay(balance_in_mBTC);
  }
  else if (bet_value === "0.001" && balance_in_dBTC > 0)
  {
    credit_value = "0.1";
    skinComp_mc.seal_dBTC._visible = true;
    skinComp_mc.seal_cBTC._visible = false;
    skinComp_mc.seal_mBTC._visible = false;
    fncSetMoneyDisplay(balance_in_dBTC);
  }
  else if (bet_value === "0.001" && balance_in_cBTC > 0)
  {
    credit_value = "0.01";
    skinComp_mc.seal_dBTC._visible = false;
    skinComp_mc.seal_cBTC._visible = true;
    skinComp_mc.seal_mBTC._visible = false;
    fncSetMoneyDisplay(balance_in_cBTC);
  }
  else
  {
    throw 'invalid credit value or balance'
  }
  if (balance_in_dBTC === 0 && balance_in_cBTC === 0)
  {
    fncButtonDisable(changeValueButton_mc,changevalue_colour_off);
  }
};
changeValueButton_mc.onRelease = function():Void  {
  
  fncChangeValue(credit_value);
  // SOUND FX                                                                                                                                                                                                                                                                                   
  if (soundFXon_bool == true) {
    slot_coin_sound.start(0,1);
  }
  //fncWinButtonEnable();
}

changeValueButton_mc.onRollOver = function():Void  {
  fncButtonRoll(this,changevalue_colour_over);
};
changeValueButton_mc.onRollOut = function():Void  {
  fncButtonRoll(this,changevalue_colour_up);
};
changeValueButton_mc.onDragOut = function():Void  {
  this.onRollOut();
};
changeValueButton_mc.onReleaseOutside = function():Void  {
  this.onRollOut();
};

// --------------------------------------------------
// BET BUTTON
// --------------------------------------------------
betButton_mc.onRollOver = function():Void  {
  fncButtonRoll(this,bet_colour_over);
};
betButton_mc.onPress = function():Void  {
  //
};

fncChangeBetValue = function():Void {
  if (coinsPlayedCurrent_num < coinsPlayedMax_num && coinsPlayedCurrent_num < moneyCurrent_num)
  {
    coinsPlayedCurrent_num++;
    fncSetCoinsDisplay(coinsPlayedCurrent_num);
  } 
  else
  {
    coinsPlayedCurrent_num = 1;
    fncSetCoinsDisplay(coinsPlayedCurrent_num);
  }
};
betButton_mc.onRelease = function():Void  {
  fncChangeBetValue();
  // SOUND FX                                                                                                                                                                                                                                                                                   
  if (soundFXon_bool == true) {
    slot_coin_sound.start(0,1);
  }
  //fncWinButtonEnable();
};
betButton_mc.onRollOut = function():Void  {
  fncButtonRoll(this,bet_colour_up);
};
betButton_mc.onDragOut = function():Void  {
  this.onRollOut();
};
betButton_mc.onReleaseOutside = function():Void  {
  this.onRollOut();
};
// --------------------------------------------------
// BET MAX BUTTON
// --------------------------------------------------
betMaxButton_mc.onRollOver = function():Void  {
  fncButtonRoll(this,betmax_colour_over);
};
betMaxButton_mc.onPress = function():Void  {
  //
};
betMaxButton_mc.onRelease = function():Void  {
  if (coinsPlayedCurrent_num <= coinsPlayedMax_num) {
    if (coinsPlayedCurrent_num < moneyCurrent_num) {
      coinsPlayedCurrent_num = coinsPlayedMax_num;
    } else {
      coinsPlayedCurrent_num = moneyCurrent_num;
    }
    fncSetCoinsDisplay(coinsPlayedCurrent_num);
    // SOUND FX 
    if (soundFXon_bool == true) {
      slot_coin_sound.start(0,1);
    }
    fncButtonDisable(payTableButton_mc,paytable_colour_off);
    fncButtonDisable(betButton_mc,bet_colour_off);
    fncButtonDisable(changeValueButton_mc,changevalue_colour_off);
    fncButtonDisable(betMaxButton_mc,betmax_colour_off);
    fncButtonDisable(spinButton_mc,spin_colour_off);
    //fncWinButtonDisable();
    //
    betmax_pressed_bool = true;
    spinButton_mc.onRelease();
  }
};
betMaxButton_mc.onRollOut = function():Void  {
  fncButtonRoll(this,betmax_colour_up);
};
betMaxButton_mc.onDragOut = function():Void  {
  this.onRollOut();
};
betMaxButton_mc.onReleaseOutside = function():Void  {
  this.onRollOut();
};

// --------------------------------------------------
// PAY TABLE
// --------------------------------------------------
payTable_mc._alpha = 0;
//
// INSERT PAYOUT VALUES
for (var i:Number = 1; i <= payoutLevels_num; i++) {
  for (var j:Number = 1; j <= 3; j++) {
    this["payTable_mc"]["payout_" + i + "_" + j].selectable = false;
    this["payTable_mc"]["payout_" + i + "_" + j].text = eval("payoutLevel_" + i + "_num") * j;
  }
}
//
payTableButton_mc.onRollOver = function():Void  {
  fncButtonRoll(this,paytable_colour_over);
};
payTableButton_mc.onPress = function():Void  {
  //
};
payTableButton_mc.onRelease = function():Void  {
  if (paytable_pressed_bool == false) {
    if (moneyCurrent_num == 0) {
      fncButtonDisable(resetButton_mc,reset_colour_off);
    }
    fncButtonDisable(betButton_mc,bet_colour_off);
    fncButtonDisable(changeValueButton_mc,bet_colour_off);
    fncButtonDisable(betMaxButton_mc,betmax_colour_off);
    if (coinsPlayedCurrent_num > 0) {
      fncButtonDisable(spinButton_mc,spin_colour_off);
    }
    paytable_pressed_bool = true;
    //
    if (payTable_mc.paytable_bg_mc.enabled != true) {
      payTable_mc.paytable_bg_mc.enabled = true;
    }
    if (payTable_mc.useHandCursor != true) {
      payTable_mc.useHandCursor = true;
    }
    //                                   
    Tweener.removeTweens(payTable_mc,"_alpha");
    Tweener.addTween(payTable_mc,{_alpha:100, time:0.5, transition:"linear"});
  } else {
    if (moneyCurrent_num == 0) {
      fncButtonEnable(resetButton_mc,reset_colour_up);
    }
    fncButtonEnable(betButton_mc,bet_colour_up);
    fncButtonEnable(changeValueButton_mc,changevalue_colour_up);
    fncButtonEnable(betMaxButton_mc,betmax_colour_up);
    if (coinsPlayedCurrent_num > 0) {
      fncButtonEnable(spinButton_mc,spin_colour_up);
    }
    paytable_pressed_bool = false;
    //
    if (payTable_mc.paytable_bg_mc.enabled != false) {
      payTable_mc.paytable_bg_mc.enabled = false;
    }
    if (payTable_mc.useHandCursor != false) {
      payTable_mc.useHandCursor = false;
    }
    //                                   
    Tweener.removeTweens(payTable_mc,"_alpha");
    Tweener.addTween(payTable_mc,{_alpha:0, time:0.5, transition:"linear"});
  }
};
payTableButton_mc.onRollOut = function():Void  {
  fncButtonRoll(this,paytable_colour_up);
};
payTableButton_mc.onDragOut = function():Void  {
  this.onRollOut();
};
payTableButton_mc.onReleaseOutside = function():Void  {
  this.onRollOut();
};
//
payTable_mc.paytable_bg_mc.onRelease = function():Void  {
  payTableButton_mc.onRelease();
};
payTable_mc.paytable_bg_mc.enabled = false;
payTable_mc.useHandCursor = false;
// **************************************************
// CALLBACK FUNCTIONS
// **************************************************
_global.fncPlayMainTimeline = function():Void  {
  if (_level0.stopped_bool = true) {
    _level0.stopped_bool = false;
    _level0.play();
  }
};
MovieClip.prototype.fncPlayParentTimeline = function():Void  {
  if (this._parent.stopped_bool == true) {
    this._parent.stopped_bool = false;
    this._parent.play();
  }
};
MovieClip.prototype.fncPlayTimeline = function():Void  {
  if (this.stopped_bool == true) {
    this.stopped_bool = false;
    this.play();
  }
};
// **************************************************
// PAUSE
// **************************************************
MovieClip.prototype.pauseMe = function(seconds):Void  {
  clearInterval(this.pause_interval);
  this.pause_interval = setInterval(fncPauseMe, 1, seconds, this);
  this.timerMark_num = getTimer();
  this.stopped_bool = true;
  this.stop();
};
_global.fncPauseMe = function(seconds, pauseObject):Void  {
  if ((getTimer() - eval(pauseObject).timerMark_num) < (seconds * 1000)) {
    //--> Stay paused
  } else {
    clearInterval(eval(pauseObject).pause_interval);
    eval(pauseObject).stopped_bool = false;
    eval(pauseObject).play();
  }
};
// **************************************************
// FUNCTION CALLS
// **************************************************
fncButtonDisable(resetButton_mc,reset_colour_off);
fncButtonDisable(payTableButton_mc,paytable_colour_off);
fncButtonDisable(betButton_mc,bet_colour_off);
fncButtonDisable(changeValueButton_mc,changevalue_colour_off);
fncButtonDisable(betMaxButton_mc,betmax_colour_off);
fncButtonDisable(spinButton_mc,spin_colour_off);
//fncWinButtonDisable();
//
fncInitDisplay();
// **************************************************
