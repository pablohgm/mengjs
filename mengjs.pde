/** Pablo Gonzalez M.
* GPL v3 
*/

float currentPosition = 0;
int MARGIN = 15;
int GREEN_BTN_WIDTH = 53;
int GREEN_BTN_HEIGHT = 179;
int RED_BTN_WIDTH = 135;
int RED_BTN_HEIGHT = 179;


Maxim maxi;
AudioPlayer player;
AudioPlayer greenPlayer;
AudioPlayer redPlayer;
boolean buttonOn;
boolean greenEffectOn;
boolean redEffectOn;
int redCounter = 0;
float speedAdjust=1.0;

PImage [] vinils;
PImage btnOff;
PImage btnOn;
PImage btnGreen;
PImage btnRed;
PImage backgroundImage;
PImage [] speedLights;
PImage [] offLights;

/* @pjs preload="images/mix-console.png"; */

void setup()
{
    size(555,555);
    backgroundImage = loadImage("images/mix-console.png");
    maxi = new Maxim(this);
    player = maxi.loadFile("beat3.wav");
    player.setLooping(true);
    greenPlayer = maxi.loadFile("piano-effect.wav");
    greenPlayer.setLooping(true);
    redPlayer = maxi.loadFile("splash.wav");
    vinils = loadImages("images/vinils/vinil",".png", 15);
    btnOff = loadImage("images/off.png");
    btnOn = loadImage("images/on.png");
    btnGreen = loadImage("images/effects/touch1.png");
    btnRed = loadImage("images/effects/touch2.png");
    speedLights = loadImages("images/speedLights/sl",".png",11);
    offLights = loadImages("images/speedLights/off",".png",11);
}

void draw()
{ 
    background(backgroundImage);
    drawSpeed();
    counterPlayerRed();
    
    if(greenEffectOn){
      image(btnGreen, GREEN_BTN_WIDTH, GREEN_BTN_HEIGHT);
    }
    
   if(redEffectOn){
      image(btnRed, RED_BTN_WIDTH, RED_BTN_HEIGHT);
    }
    
   if(buttonOn){
     image(btnOn, btnOn.width, btnOn.width);
   }else{
     image(btnOff, btnOn.width, btnOn.width);
   } 
    
    image(vinils[(int)currentPosition], width/2, MARGIN);
    if(buttonOn){
        player.speed(speedAdjust);
        currentPosition= currentPosition+1*speedAdjust;
    }
   if(currentPosition >= vinils.length)     
   {
         currentPosition = 0;
    }
}

void counterPlayerRed(){
  if(redEffectOn){
    redCounter++;
    if(redCounter>50){
      redEffectOn = false;
      redCounter = 0;
    }
  }
}

void drawSpeed(){
  for(int i=0; i<offLights.length;i++){
      image(offLights[i], (MARGIN*2)*(i+1), height-(MARGIN*4));
  }
  if(buttonOn){
    int tmpSpeedPosition = calculeSpeed(speedAdjust, 1.98);
    for(int i=0; i<tmpSpeedPosition && i<speedLights.length;i++){
      image(speedLights[i], (MARGIN*2)*(i+1), height-(MARGIN*4));
    }
  } 
}

void mousePressed() {
  int tmpMiddleSize = btnOn.width/2;
  if(dist(mouseX-tmpMiddleSize, mouseY-tmpMiddleSize, btnOn.width, btnOn.width) < tmpMiddleSize){
    buttonOn = !buttonOn;
    if (buttonOn){
        player.cue(0);
        player.play();
    }
    else {
      stopMixConsole();
      player.stop();
      greenPlayer.stop();
      redPlayer.stop();
    }
  }
  if(buttonOn){
    startGreenEffect();
    startRedEffect();
  }
}

void startRedEffect(){
  int x1 = mouseX-(MARGIN*2);
  int x2 = RED_BTN_WIDTH;
  int y1 = mouseY-(MARGIN*2);
  int y2 = RED_BTN_HEIGHT;
  int max = btnRed.width/2+(MARGIN/2);
  if(dist(x1, y1, x2, y2) < max){
    redEffectOn = !redEffectOn;
    if (redEffectOn){
        redPlayer.cue(0);
        redPlayer.play();
    }
    else {
      redPlayer.stop();
    }
  }
}

void startGreenEffect(){
  int x1 = mouseX-(MARGIN*2);
  int x2 = GREEN_BTN_WIDTH;
  int y1 = mouseY-(MARGIN*2);
  int y2 = GREEN_BTN_HEIGHT;
  int max = btnGreen.width/2+(MARGIN/2);
  if(dist(x1, y1, x2, y2) < max){
    greenEffectOn = !greenEffectOn;
    if (greenEffectOn){
        greenPlayer.cue(0);
        greenPlayer.play();
    }
    else {
      greenPlayer.stop();
    }
  }
}

void mouseDragged() {
 if (mouseX > width/2) {
   speedAdjust=map(mouseY,0,width,0,2);
 } 
}

public int calculeSpeed(float speed, float max){
  int tmpSpeed = (int)((speed*10)/max);
  return tmpSpeed;
}

void stopMixConsole(){
  player.stop();
  greenPlayer.stop();
  redPlayer.stop();
  redEffectOn = false;
  greenEffectOn = false;
}

