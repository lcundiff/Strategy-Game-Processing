//EDIT:4/16/2017 //<>//
// IMPORTS
import processing.video.*;
import processing.sound.*;
//////////////// GLOBALS ////////////////////
SoundFile music1; // holds music
SoundFile noise; // holds a noise
Movie myMovie ; // movie object
Movie warFootage ; // movie object
//define global colors for map tile reading
color grass = color(0, 255, 0);
color path = color(200, 200, 200);
color mtn = color(183, 110, 0);
color forest = color(0, 150, 0);
color city = color(125, 125, 125);
color water = color(0, 0, 150);
// global variables//pArray[playerTurn].armyList
int chooseMap = 0; 
map m; // global object
PImage img, HUD, bgrid, camo; // graphic layouts
PImage tank1B, tank1R;  
int gameState =0; //using "gameState" to determine the game's current state: 0-menu, 1-map screen, 2-battle scene,3-pause,4-formation
int battleState=0; //use the battleState to facilitate battles, 0 will probably be used 
boolean gamePaused = false; // 
boolean moving=false;
int cx, cy, fx, fy, fc; //cursor x and y position, used for selecting units/tiles, formation cursor fx, fy, used to pass into formchange
ArrayList<army> p1a = new ArrayList<army>(); // player 1 army arrayL
ArrayList<army> p2a = new ArrayList<army>(); // player 2 army arrayL
ArrayList<effect> eList = new ArrayList<effect>(); //effects array for holding all effects being shown
PFont dialogF; //fonts, one for dialogs and one for the menu
PFont menuFont; 
int playerTurn = 0; //0 - blue turn, 1 - red turn
battleGrid batGrid = new battleGrid(); //the battleGrid facilitates the battle scene
int timer; //used for timing things
int si=-1; int di=-1; //selected index, defender index, the index of the army in their aList


void setup() {
  size(832, 512);
  // MAPS
  img = loadImage("map.png"); // access map1 at img
  //map2 here
  //map3 here
  m = readImg(img); //turns the loaded image into a map object, complete with tiles
  //VIDEOS
   warFootage = new Movie(this, "war.mp4"); // 
   myMovie = new Movie(this, "movie.mov"); //.mpg for better quality
   myMovie.loop();
   warFootage.loop(); 
   // SOUNDS
   music1 = new SoundFile(this, "piano.mp3");
   music1.loop(); // plays background music
   music1.amp(0); 
  // GRAPHICS AND THINGS
  HUD=loadImage("HUD.png");
  bgrid = loadImage("bgrid.png");
  tank1B = loadImage("tank1.png"); 
  tank1R = loadImage("tank1R.png"); 
  camo = loadImage("camo.jpg"); // background for setting menu
  cx=0; //used when clicking
  cy=0;
  dialogF = loadFont("dFont.vlw"); 
  menuFont = createFont("OCRAStd", 48);
}

getRect turnButton = new getRect(false, 740, 310, 50, 140); // turn button

// DRAW FUNCTION
void draw() {

  background(50); // grey background
  noStroke();
  if (gameState==0) {
    menu() ;
  }

  ////////////////////////////  GAMEPLAY

  //display current map with units, hud, etc: the map will take up a 640x384 portion, and the hud will cover the rest
  // game is now being played
  if (gameState==1 || gameState == 3 || gameState==4) { //might move gameSTate ==4 into its own handling if there's something gamebreaking
    // gameState = 3 will allow game to switch from paused to unpaused
    myMovie.stop();
    warFootage.stop(); // stop videos
    music1.amp(0.5);  // raise volume on background music
    image(HUD, 0, 0); // display
    fill(255, 60); 
    rect(turnButton.rectX, turnButton.rectY, turnButton.sizeX, turnButton.sizeY); 
    text(mouseX+","+mouseY+", cursor:"+cx+","+cy+", si: "+si, 0, 480);

    //draw formation cursor if that mode is on
    if (gameState==4) {
      fill(255, 0);
      stroke(255, 0, 0);
      strokeWeight(1);
      rect(640+fx*32, fy*32+352, 32, 32);
    }
    noStroke();
    for (int i=0; i<10; i++) { // fill in the tiles
      for (int j=0; j<6; j++) {
        if (m.tileA[i][j].move && moving) fill(m.tileA[i][j].cl+color(200, 255, 255, 50));    
        else {
          fill(m.tileA[i][j].cl);
          m.tileA[i][j].move=false;
        }
        rect(i*64, j*64, 64, 64); // tiles on map
      } // end of inner loop
    } // end of outer loop 
    // allows for game to be paused
    drawArmies(); //draws each player's armies
    drawSelector(cx, cy); //makes outline   /// method calls
    drawDialog(); //draws menu dialog to the side if unit selected
  }
  // enter battle mode here
  else if (gameState==2) { //only enter game state 2 if you have two armies, selectedA and defenderB
    background(150);
    if (battleState==0) runBattle(p1a.get(0), p1a.get(1));
    //figure out how to wait for for loop to end, advance game state then
    runAnim();
  }
  // allows for game to be paused. player must type 2
  if (gamePaused) {
    menu2();
  }

  
} // END OF DRAW

void runBattle(army A, army B) {
  batGrid.populateGrid(A, B); //fill grid with armies
  batGrid.drawGrid(); //draw grid with units in it after populating
  batGrid.simBattle(A, B); // if in battle call sim method
  battleState++;
}

boolean animating;
void runAnim() {
  batGrid.drawGrid();
  for (effect e : eList) {
      if(e.al>=0){
      animating=true;
      e.drawEff();
      e.step();
      }
      else animating=false;
  }
  if (!animating) {
    destroyDead();    
  }
}

void movieEvent(Movie m) { // this allows movies to work 
  m.read();
  //warFootage.read();
}

//reads an input image to draw the map based off of it, will eventually use this in conjunction with a file selection prompt to load maps

void mapMaker(map m) {
  //this loop should fill out the map's tile array with a new tile corresponding to the
  //color of the pixel on the map file    
  //  m.tileA[0][0]=new tile(color(0, 255, 0),0,0);
  for (int i=0; i<img.width; i++) {
    for (int j=0; j<img.height; j++) {
      m.tileA[i][j] = new tile(color(img.pixels[(i*img.width)+j]), i, j);
    } // end of inner loop
  } // end of outer loop
}


map readImg(PImage img) {
  img.loadPixels(); //FIXED
  map m = new map(img.width, img.height); 
  // INSERT MAPS HERE and call map method with different map objects to create different maps
  if (chooseMap == 1 || chooseMap == 0) { 
    mapMaker(m);
  } else if (chooseMap == 2) { 
    //mapMaker(m2);
  }
  return m;
}

void drawSelector(int x, int y) { //draw the selector as a white square
  stroke(255);
  strokeWeight(6);
  fill(0, 0, 0, 0);
  rect(x*64-3, y*64-3, 64+3, 64+3);
}

void drawArmies() {//draw armies on the maps by cycling thru army arraylists
  for (army a : p1a) {
    if (a.HP>0) a.display(0);
  }
  for (army a : p2a) {
    if (a.HP>0) a.display(1);
  }
}

void destroyDead() {
  for(army a:p1a){ //<>//
    if(a.HP<=0) p1a.remove(a);
  }
  battleState=0;
  gameState=1;
}

void drawDialog() { //to distinguish between turns, use the turn int (1 or 0) to determine if getocc is used on p1a or p2a (player 1 army, player 2 army)
  String name;
  //get name if there's something there
  if (si >= 0) {
    name = p1a.get(si).type;
  } else {
    name = "NONE"; 
  }
  fill(0);
  textAlign(LEFT, CENTER);
  textFont(dialogF, 28);
  text(name, 650, 20);
  //if there's something there, show a dialogue menu (move,fire,etc) also show health bars and such
  if (si>=0) {
    noStroke();
    textFont(dialogF, 18);
    textAlign(LEFT, BASELINE);
    text("MOVE\nFIRE\nFORMATION\nWAIT", 660, 50);
    fill(0, 255, 0);
    rect(680, 140, p1a.get(si).HP, 6);
    fill(0);
    text("HP:" + p1a.get(si).HP, 645, 150);
    text("ARMOR:" + p1a.get(si).armor, 645, 170);
    for (int h=0; h<p1a.get(si).Ucount; h++) {
      fill(200, 255, 200);
      rect(710, 180+h*20, p1a.get(si).unitC[h].HP *5, 6);
      fill(0);
      text("U" + h + " HP:" + p1a.get(si).unitC[h].HP, 645, 190+h*20);
      rect(648+p1a.get(si).unitC[h].locx*32, 360+p1a.get(si).unitC[h].locy*32, 16, 16);
    }
  }
}

int tileDistance(int x, int y, int x2, int y2) {
  return abs(x-x2)+abs(y-y2);
}

//FORMATION COMMAND

//END FORMATION COMMAND

//MOVEMENT HANDLING

//THIS is a DEPTH-FIRST SEARCH that marks movable tiles around a unit that is moving
//it goes through each adjacent tile, and then recursively goes through each of those tile's adjacent tiles until it exhausts its movement counter (mov)
//also will not allow units to travel over mountains, we're not supporting that right now
//might use another variable as an "identifier" to allow special permission for an infantry (which should be able to move over mountains) or naval units, if we make them
void DFS(tile t, int mov) {
  if (mov>=0) {
    t.move=true;
    if (t.x-1>=0 && m.tileA[t.x-1][t.y].mPen<3) DFS(m.tileA[t.x-1][t.y], mov-m.tileA[t.x-1][t.y].mPen);
    if (t.x+1<=m.w-1 && m.tileA[t.x+1][t.y].mPen<3) DFS(m.tileA[t.x+1][t.y], mov-m.tileA[t.x+1][t.y].mPen);
    if (t.y-1>=0 && m.tileA[t.x][t.y-1].mPen<3) DFS(m.tileA[t.x][t.y-1], mov-m.tileA[t.x][t.y-1].mPen);
    if (t.y+1<=m.h-1 && m.tileA[t.x][t.y+1].mPen<3) DFS(m.tileA[t.x][t.y+1], mov-m.tileA[t.x][t.y+1].mPen);
  }
}

//END MOVEMENT HANDLING

void mouseClicked() {

  if (turnButton.rectOver && gameState == 1) {//
    if (playerTurn>0) playerTurn--; 
    else if (playerTurn==0) playerTurn++;
  }

  if (gameState == 1) { // within game, on map
    if (mouseButton ==LEFT) { //left click a tile to select it and display its current occupant's stats and commands
      if (pmouseX <=640 && pmouseX > 0 && pmouseY > 0 && pmouseY <=384) {
        //this is just to get the tile that you clicked on, might just do an easier solution later, but i'm working on this one
        cx = pmouseX/64; 
        cy = pmouseY/64;
        if(moving) {
          if(m.tileA[cx][cy].move){
          p1a.get(si).locx=cx;
          p1a.get(si).locy=cy;
          }
          moving=false;
        }
        else si=m.getOcc(cx, cy, p1a);
      }      
      //formation changing
    }
    if (mouseButton ==RIGHT) { //right click to create a new army (test unit) on that tile
      if (pmouseX <=640 && pmouseX > 0 && pmouseY > 0 && pmouseY <=384) {
        cx = pmouseX/64;
        cy = pmouseY/64;
        if (m.getOcc(cx, cy, p1a) ==-1) { //checks if spot is open, makes a unit, will move this functionality over to factory tiles eventually        
          p1a.add(new army(cx, cy, "TEST", 2, 10, 5, 1, 3, 1, 8));
          si=m.getOcc(cx, cy, p1a);
        }
      }
    }
    if (mouseButton ==CENTER) { //middle click an army to remove 1 health from each of its composite units
      if (pmouseX <=640 && pmouseX > 0 && pmouseY > 0 && pmouseY <=384) {
        cx = pmouseX/64;
        cy = pmouseY/64;
        int i=-1; //i means index, it's the index of the unit retrieved in the army array
        i = m.getOcc(cx, cy, p1a);
        if (i>=0) {
          if (p1a.get(i).HP > 0) p1a.get(i).HP -=1;
          if (p1a.get(i).HP <=0) p1a.remove(i);
        }
      }
    }
  } // ends clicking in game

  if (gameState == 2) {
    gameState = 1; 
    // handling battle grid clicks
  }

  if (gameState==4 && mouseX>=641 && mouseX <=769 && mouseY>=353 && mouseY<=513) {//is formation change on and is the mouse in the formation box and left clicking
    //int i = m.getOcc(cx, cy, p1a);
    println("h");
    fx=((int)(pmouseX-640))/32;
    fy=((int)(pmouseY-352))/32;
    println(fx+","+fy);
    if (!(p1a.get(si).hasUnit(fx, fy))) {
      p1a.get(si).changeSpot(fx, fy, fc);
      fc++;
    }
    if(fc>=p1a.get(si).Ucount) gameState=1; //<>//
  }
}

void keyPressed() {
  if (key=='e'&&gameState==1) {
    //use to switch turns, will figure this mechanism out later (use pointers)
  }
  if (key=='b'&&gameState==1) {
    gameState=2;
  }
  if (key=='c'&&gameState==1) {
    p1a.remove(si);
  }
  if (key=='f'&&gameState==1) { //hit f to change formation 
    fx=0;
    fy=0;
    fc=0;
    gameState=4;
  }
  if (key=='m'&&gameState==1) { //hit m to move
    if (si>=0) {
         moving=true;
         DFS(m.tileA[p1a.get(si).locx][p1a.get(si).locy], p1a.get(si).mov);
         } else moving=false;
  }
  if (key=='p'&&gameState==1) {
    gameState = 3; 
    gamePaused = true;
  }
}