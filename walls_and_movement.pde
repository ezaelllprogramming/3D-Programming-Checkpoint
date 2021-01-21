import java.awt.Robot;

color black = #000000;
color white = #FFFFFF;
color dullBlue = #7092BE;

PImage mossyStone;
PImage oakPlanks;

int gridSize;
PImage map;

Robot Geraldo;

float eyex,eyey,eyez,focusx,focusy,focusz,upx,upy,upz; //camera position, facing point, tilt axis
boolean wkey, akey, skey, dkey;

float leftRightAngle, upDownAngle;

void setup() {
 
  mossyStone = loadImage("Mossy_Stone_Bricks.png");
  oakPlanks = loadImage("Oak_Planks.png");
  textureMode(NORMAL);
  
  try {
    Geraldo = new Robot();
  }
  catch(Exception e) {
    e.printStackTrace();
  }
 
  size(displayWidth,displayHeight,P3D);
 
  eyex = width/2;
  eyey = 6*height/7;
  eyez = height/2;
 
  focusx = width/2;
  focusy = height/2;
  focusz = height/2-100;
 
  upx = 0;
  upy = 1;
  upz = 0;
  
  map = loadImage("map.png");
  gridSize = 100;
}

void draw() {
  //background(60,0,60);
  background(222);
  
  pointLight(255,255,255,eyex,eyey,eyez);
 
  camera(eyex,eyey,eyez,focusx,focusy,focusz,upx,upy,upz);
 
  move();
  drawAxis();
  drawFloor(-2000,2000,height,gridSize);
  drawFloor(-2000,2000,height-gridSize*4,gridSize);
  drawMap();
  //drawFloor(-2000,2000,height,100,#00FF00);
  //drawFloor(-2000,2000,0,100,#00FF00);
  //drawFloor(-1999,1999,height,100,#00FFFF);
  //drawFloor(-1999,1999,0,100,#00FFFF);
}

void drawMap() {
  for (int x = 0; x < map.width; x++) {
    for (int y = 0; y < map.height; y++) {
      color c = map.get(x,y);
      if (c == dullBlue) {
        texturedCube(x*gridSize-2000,height-gridSize,y*gridSize-2000,mossyStone,gridSize);
        texturedCube(x*gridSize-2000,height-gridSize*2,y*gridSize-2000,mossyStone,gridSize);
        texturedCube(x*gridSize-2000,height-gridSize*3,y*gridSize-2000,mossyStone,gridSize);
      }
      if (c == black) {
        texturedCube(x*gridSize-2000,height-gridSize,y*gridSize-2000,oakPlanks,gridSize);
        texturedCube(x*gridSize-2000,height-gridSize*2,y*gridSize-2000,oakPlanks,gridSize);
        texturedCube(x*gridSize-2000,height-gridSize*3,y*gridSize-2000,oakPlanks,gridSize);
      }
    }
  }
}

void move() {
  pushMatrix();
 
  //ambientLight(128, 128, 128);
  //directionalLight(128, 128, 128, 0, 0, -1);
  //lightFalloff(1, 0, 0);
  //lightSpecular(0, 0, 0);
 
  translate(focusx,focusy,focusz);
  fill(200);
  noStroke();
  //sphere(10);
  popMatrix();
 
  if (akey && canMoveLeft()) {
    eyex -= cos(leftRightAngle + radians(90))*20;
    eyez -= sin(leftRightAngle + radians(90))*20;
  }
  if (dkey && canMoveRight()) {
    eyex += cos(leftRightAngle + radians(90))*20;
    eyez += sin(leftRightAngle + radians(90))*20;
  }
  if (wkey && canMoveForward()) {
    eyex += cos(leftRightAngle)*20;
    eyez += sin(leftRightAngle)*20;
  }
  if (skey && canMoveBackwards()) {
    eyex -= cos(leftRightAngle)*20;
    eyez -= sin(leftRightAngle)*20;
  }
 
  focusx = eyex + cos(leftRightAngle)*100;
  focusy = eyey + tan(upDownAngle)*100;
  focusz = eyez + sin(leftRightAngle)*100;
 
  leftRightAngle = leftRightAngle + (mouseX - pmouseX)*0.01;
  upDownAngle = upDownAngle + (mouseY - pmouseY)*0.01;
 
  if(upDownAngle > PI/2.5) upDownAngle = PI/2.5;
  if(upDownAngle < -PI/2.5) upDownAngle = -PI/2.5;
 
  if (mouseX > width-2) Geraldo.mouseMove(3,mouseY);
  if (mouseX < 2) Geraldo.mouseMove(width-3, mouseY);
}

boolean canMoveForward() {
 float fwdx, fwdy, fwdz;
 float leftx, lefty, leftz;
 float rightx,righty,rightz;
 int mapx, mapy;
 
 fwdx = eyex + cos(leftRightAngle)*200;
 fwdy = eyey;
 fwdz = eyez + sin(leftRightAngle)*200;
 
 mapx = int(fwdx+2000) / gridSize;
 mapy = int(fwdz+2000) / gridSize;
 
 if (map.get(mapx,mapy) == white) {
  return true; 
 }else{
   return false;
 }
}

boolean canMoveLeft() {
  float lx, ly, lz;
 int mapx, mapy;
 
 lx = eyex + sin(leftRightAngle)*200;
 ly = eyey;
 lz = eyez;
 
 mapx = int(lx+2000) / gridSize;
 mapy = int(lz+2000) / gridSize;
 
 if (map.get(mapx,mapy) == white) {
  return true; 
 }else{
   return false;
 }
}

boolean canMoveRight() {
  float rx, ry, rz;
 int mapx, mapy;
 
 rx = eyex - sin(leftRightAngle)*200;
 ry = eyey;
 rz = eyez;
 
 mapx = int(rx+2000) / gridSize;
 mapy = int(rz+2000) / gridSize;
 
 if (map.get(mapx,mapy) == white) {
  return true; 
 }else{
   return false;
 }
}

boolean canMoveBackwards() {
  float bwdx, bwdy, bwdz;
 int mapx, mapy;
 
 bwdx = eyex - cos(leftRightAngle)*200;
 bwdy = eyey;
 bwdz = eyez - sin(leftRightAngle)*200;
 
 mapx = int(bwdx+2000) / gridSize;
 mapy = int(bwdz+2000) / gridSize;
 
 if (map.get(mapx,mapy) == white) {
  return true; 
 }else{
   return false;
 }
}

void drawAxis() {
 
}

void drawFloor(int start, int end, int level, int gap) {
  int x = start;
  int z = start;
  stroke(0);
  strokeWeight(1);
  while(z < end) {
    texturedCube(x,level,z,oakPlanks,gap);
    x = x + gap;
    if (x >= end) {
     x = start;
     z = z + gap;
    }
  }
}

void keyPressed() {
  if (key == 'w' || key == 'W') wkey = true;
  if (key == 'a' || key == 'A') akey = true;
  if (key == 's' || key == 'S') skey = true;
  if (key == 'd' || key == 'D') dkey = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') wkey = false;
  if (key == 'a' || key == 'A') akey = false;
  if (key == 's' || key == 'S') skey = false;
  if (key == 'd' || key == 'D') dkey = false;
}
