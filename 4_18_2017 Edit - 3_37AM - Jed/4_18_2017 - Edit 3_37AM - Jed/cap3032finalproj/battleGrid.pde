class battleGrid {
  //the battleGrid class is what will handle combat by creating an entirely new scene and simulating the battle using that
  int counter=2; // this is good idea to limit shots since processing will keep units shooting
  //vars
  int w, h;
  bTile[][] bArray = new bTile[4][5]; // 4across by 5down matrix
  bTile[][] aArray = new bTile[4][5]; 
  //constructor
  battleGrid() {
    w=width;
    h=height;
    for(int i=0;i<4;i++){
      for(int j=0;j<5;j++){
        aArray[i][j]=new bTile();
      }
    }
    for(int i=0;i<4;i++){
      for(int j=0;j<5;j++){
        bArray[i][j]=new bTile();
      }
    }
  }
  //functions
  void drawGrid() { //called when initiating combat, graphically draws the battleGrid based off of w and h
    //draw grid image
    image(bgrid, 0, 0);
    for (int i=0; i<aArray.length; i++) {
      for (int j=0; j<aArray[i].length; j++) {
        if (aArray[i][j].live) {
          noStroke();
          fill(255,0,0); 
          rect(i*64+48, j*64+48, 32, 32);
        }
      }
    }
    for (int i=0; i<bArray.length; i++) {
      for (int j=0; j<bArray[i].length; j++) {
        if (bArray[i][j].live) {
          noStroke();
          fill(0,0,255); 
          rect((9-i)*64+48, j*64+48, 32, 32);
        }
      }
    }
  }

  void populateGrid(army a, army b) {
    int x,y;
    for(int i=0;i<a.Ucount;i++){
      x=a.unitC[i].locx;
      y=a.unitC[i].locy;
      if(a.unitC[i].HP>0) {aArray[x][y]=new bTile(a.unitC[i],i);
      println("live at"+x+","+y);}
    }
    for(int i=0;i<b.Ucount;i++){
      x=b.unitC[i].locx;
      y=b.unitC[i].locy;
      if(b.unitC[i].HP>0) bArray[x][y]=new bTile(b.unitC[i],i);
    }
    
    battleState=1;
  }

  //go thru a's tile array and fire for each live unit, then go thru b's tile array and fire for each remaining live unit
  void simBattle(army a, army b) {
    //army a fires on army b - nested for loops cycle through aArray, which holds the attacking army
    for (int i=0; i<a.Ucount; i++) {
        // if unit, then fire the unit
        if (a.unitC[i].HP>=0) { // there is a unit at bTile
          // we could also add soldier objects to bTile class as well which may make things easier
            int I = a.unitC[i].fireMethod(bArray) ; // triggers the fire method using general variables of unit class
            //I is the 1-dimensional index of the unit that's being hit on the 2-dimensional array
            if(I>=0) { //check if anything was there, -1 means no units found
              int tx = I%4; //converting I back to its x and y variables
              int ty = (I-tx)/4;
              eList.add(new effect(a.unitC[i].locx*64+64,a.unitC[i].locy*64+64,64*((3-tx)+6-a.unitC[i].locx),5,0)); //replace this with projectile later
              int dmg=max(0, a.unitC[i].atkPower-b.armor-m.tileA[b.locx][b.locy].def);
              b.unitC[bArray[tx][ty].index].HP -=dmg;
              if(b.unitC[bArray[tx][ty].index].HP<=0) bArray[tx][ty].live=false;
              b.HP=max(0,b.HP-dmg);
            }
            else eList.add(new effect(a.unitC[i].locx*64+64,a.unitC[i].locy*64+64,64*((3-a.unitC[i].locx)+8),5,3));
        }
    }
    //fire back
    for (int i=0; i<b.Ucount; i++) {
        if (b.unitC[i].HP>=0) {
            int I = b.unitC[i].fireMethod(aArray) ;
            if(I>=0) { 
              print("HIT! ");
              int tx = I%4; 
              int ty = (I-tx)/4;
              eList.add(new effect((9-b.unitC[i].locx)*64+64,b.unitC[i].locy*64+64,64*((3-tx)+6-a.unitC[i].locx),-5,0)); //replace this with projectile later
              int dmg=max(0, b.unitC[i].atkPower-a.armor-m.tileA[a.locx][a.locy].def);
              println(aArray[tx][ty].index+":"+dmg);
              a.unitC[aArray[tx][ty].index].HP -= dmg;
              a.HP=max(0,a.HP-dmg);
            }
            else eList.add(new effect((9-b.unitC[i].locx)*64+64,b.unitC[i].locy*64+64,64*((3-a.unitC[i].locx)+6),-5,3));
        }
    }
    
    /*army b fires back on army a
    for (int i=0; i<bArray.length; i++) {
      for (int j=0; j<bArray[i].length; j++) {
        // if unit, then fire the unit
        if (bArray[i][j].live==true) { // there is a unit at bTile
          // we could also add soldier objects to bTile class as well which may make things easier
          int I = b.units[i][j].fireMethod(aArray) ; // triggers the fire method using general variables of unit class
          if (I>=0) {
            int tx = I%4;
            int ty = (I-tx)/4;
            eList.add(new effect((9-i)*64+64,j*64+64,64*((3-i)+(4-tx)+2),-5,0));
            //eList.add(new effect(i*64+64,j*64+64,64*(tx+10-i),-5,0));
            int dmg=max(0, b.units[i][j].atkPower-a.armor-m.tileA[a.locx][a.locy].def);
            a.units[tx][ty].HP = max(0,a.units[tx][ty].HP-dmg);
            a.HP-=dmg;
          }
        }
      }
    } */  
  }
}