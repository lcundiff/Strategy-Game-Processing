
// Menu class is called at beginning of game and when game is restarted

// Position of square button
int rectWidth = 200, rectHeight = 100;     // Diameter of rect
int wx = width/2; //default x position for anything rather than (0,0)
int hy = height/2; // default y position for anything rather than (0,0)
String word = "", s = "" ; // initalizes strings so that words can be added later 

boolean game = false, game1 = false, game2 = false, finished= false; 

class getRect {
  int rectX, rectY, sizeX, sizeY;  
  color rectColor;
  color rectHighlight;
  boolean rectOver;
  public getRect(boolean over, int x, int y, int sx, int sy) {
    rectOver = over ; 
    rectX = x; 
    rectY = y; 
    sizeX = sx; 
    sizeY = sy;
  }

  void buttonColor(color col1, color col2) {

    if (rectOver) {
      fill(col1);
    } else {
      fill(col2);
    }
  }
}


//RECTANGLE BUTTONS
getRect rex1 = new getRect(false, wx+175, hy+300, 400, 75); // Start button
getRect rex2 = new getRect(false, wx+320, hy+385, 100, 60); // QUIT BUTTON
getRect rex3 = new getRect(false, wx+20, hy+250, 320, 130); // Begin Game button
getRect rex4 = new getRect(false, wx+440, hy+260, 230, 80); // settings button
getRect rex5 = new getRect(false, wx, hy+350, 130, 60); // back button
getRect mapRex1 = new getRect(false, wx+482, hy-9, 216, 120); // settings button

color currentColor1 = (int)random(100, 350); // sets the background color
color currentColor2 = (int)random(0, 200); // sets the background color


////////////////////////Settings menu
void thirdMenu() {
  image(camo, 0, 0); 
  //background(currentColor2, 0,100);
  fill(20);
  stroke(0);
  strokeWeight(1); // thin outline
  textFont(dialogF, 70);
  text("Choose Map", wx-15, hy+30); 
  textSize(30); 
  fill(#5DFFFB); 
  textFont(dialogF, 30);
  text("Back", rex5.rectX+20, rex5.rectY-10) ; 

  stroke(0); 
  if (chooseMap == 0) {
    image(img, width - 300, height - 470, 216, 120);
  } else if (chooseMap == 1) {
    image(img, width - 300, height - 470, 216, 120);
    stroke(#F9FF58);
    strokeWeight(4); // makes thicker outline to highlight
    fill(255, 100); 
    rect(mapRex1.rectX, mapRex1.rectY, mapRex1.sizeX, mapRex1.sizeY);
  }

  /// ADD MORE MAPS HERE

  fill(#5DFFFB);
  rect(rex5.rectX, rex5.rectY, rex5.sizeX, rex5.sizeY); // Edit 'back' button attributes here for settings
}


////////////////// SecondMenu
void secondMenu() {
  if (!game1)
    image(warFootage, 0, 0);//plays second video
  //warFootage.play(); 
  //background(currentColor2, 0,100);

  // BEGINING OF MENU


  stroke(#1F9000);
  strokeWeight(3); 
  rex3.buttonColor((int)random(#095000, #0F8300), #4D4D4D); // edit begin game button color here
  rect(rex3.rectX, rex3.rectY, rex3.sizeX, rex3.sizeY); // edit beegin game button attibutes here
  fill(255);
  textFont(dialogF, 50);
  text("BEGIN GAME", rex3.rectX+25, rex3.rectY+80); 

  rex4.buttonColor(#666767, #393939); // edit settings button color
  rect(rex4.rectX, rex4.rectY, rex4.sizeX, rex4.sizeY); // Edit button attributes here for settings
  fill(255);
  textFont(dialogF, 45);
  text("SETTINGS", rex4.rectX+15, rex4.rectY+50); 

  stroke(0);

  if (game1==true) {
    thirdMenu();
  }
}

///// MENU FUNCTION START
void menu() {
  if (!game)
    image(myMovie, -10, 0); 

  //background(currentColor1, 0,100); // FOR FASTER LOAD CANCELS VIDEO
  update();  //calls update method by putting in mouse coordinates

  // BEGINING OF MENU
  stroke(#00B1C6);
  textFont(menuFont, 60);
  fill(0);

  text("Logan's and Jed's", wx, hy+40, -30); 
  text("Game", wx+300, hy+104, -30) ;
  filter(BLUR, 0); 
  fill(#00A2D1);
  text("Logan's and Jed's", wx, hy+35); 
  text("Game", wx+300, hy+100);

  strokeWeight(3);
  rex1.buttonColor(#666767, #393939); 
  rect(rex1.rectX, rex1.rectY, rex1.sizeX, rex1.sizeY);
  fill(255); 
  textFont(dialogF, 28);
  textSize(60); 
  text("START", rex1.rectX+110, rex1.rectY+60); 
  rex2.buttonColor(#666767, #393939); 
  rect(rex2.rectX, rex2.rectY, rex2.sizeX, rex2.sizeY);
  fill(255); 
  textSize(21); 
  textFont(dialogF, 28);
  text("QUIT", rex2.rectX+20, rex2.rectY+40);
  if (game==true) {
    secondMenu();
  }
} // end of MENU1

// menu2 is accessed in game
void menu2() {
  image(camo, 0, 0); 
  //background(currentColor2, 0,100);
  update();
  fill(20);
  stroke(0);
  strokeWeight(1); // thin outline
  textFont(dialogF, 70);
  text("Game Paused", wx-15, hy+30); 
  textSize(30); 
  textFont(dialogF, 30);
  rex5.buttonColor(#5DFFFB, #393939); 
  text("Back", rex5.rectX+20, rex5.rectY-10) ;  
  rect(rex5.rectX, rex5.rectY, rex5.sizeX, rex5.sizeY); // Edit 'back' button attributes here for settings
  // quit button
  stroke(#00B1C6);
  strokeWeight(3); 
  rex2.buttonColor(#666767, #393939); 
  rect(rex2.rectX, rex2.rectY, rex2.sizeX, rex2.sizeY);
  fill(255); 
  textSize(21); 
  textFont(dialogF, 28);
  text("QUIT", rex2.rectX+20, rex2.rectY+40);
}

// this will set RectOver value for each rect button put into the method
void isOver(getRect r) {
  if ( overRect(r.rectX, r.rectY, r.sizeX, r.sizeY) ) { // begin game button
    r.rectOver = true;
  } else {
    r.rectOver = false ;
  }
}


void update() { // this decides if the mouse is over a certain button

  isOver(rex1) ; 
  isOver(rex2) ; 
  isOver(rex3) ; 
  isOver(rex4) ; 
  isOver(rex5) ; 
  isOver(mapRex1) ;
}


void mousePressed() {

  if (gameState == 0) { // we are within menu1
    ///////////// MAP SELECTION
    if (mapRex1.rectOver && game1) {
      chooseMap = 1 ;
    } else if (rex4.rectOver && game && !game1) { // settings button
      game1 = true; // proceeds to third menu
    }


    if (rex5.rectOver && (game1 || gamePaused) ) { // back button can be used in pause screen or in settings screen (easier like this) 
      game1 = false;    

      if (gamePaused) {
        gamePaused= false; 
        gameState = 1;
      }
    } else if (rex2.rectOver && ((!game && !game1) || gamePaused)) { // quit button can only be clicked in first menu
      exit();
    }

    if (gameState == 0) { // we are within menu1
      ///////////// MAP SELECTION
      if (mapRex1.rectOver && game1) {
        chooseMap = 1 ;
      } else if (rex4.rectOver && game && !game1) { // settings button
        game1 = true; // proceeds to third menu
      } else if (rex1.rectOver && !game && !game1) { // start button can only be clicked in first menu
        game = true;  //proceeds to second menu
      } else if (rex3.rectOver && game && !game1) { // begin game button
        gameState=1; 
        draw();
      }
    }
  }
}
// rectangle buttons
boolean overRect(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

// this is used if we want circle buttons
boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if (sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}