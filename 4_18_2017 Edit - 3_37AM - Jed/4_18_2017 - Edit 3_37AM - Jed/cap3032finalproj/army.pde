//armies are what display on the map, units display on the battle grid
// army class is called when unit is being selected by user to do something


// army super class
public  class army {
  //a.atk
  String type;
  int HP,armor,Ucount;
  int atk,mov,range;
  int locx, locy; 
  unit[] unitC;
  //constructor
  public army(int lx, int ly, String ty, int ar, int h, int co,int a,int m,int r,int at){
        atk=at;
        locx = lx; 
        locy = ly;
        type = ty;
        mov = m;
        armor = ar;
        range=r;
        Ucount = co;
        unitC=new unit[co];
        for(int i=0; i<co;i++) unitC[i]=new unit(0,i,ty,h,at);
        HP = h*co;
  }
  

  army(){}
  //functions - need a "select" function to display information on the right side of the screen
  void display(int team){
    noStroke();
    if(team==0){
      fill(255,0,0);
      image(tank1B,locx*64+10,locy*64+10,40,40);
    }
    if(team==1){ 
    fill(0,0,255);
    image(tank1R,locx*64+10,locy*64+10,40,40);
    }
  }
  
  boolean hasUnit(int i,int j){
    boolean b=false;
    for(int h=0;h<Ucount;h++){
      if(unitC[h].locx==i && unitC[h].locy==j) b=true;
    }
    return b; //<>//
  }
  
  void changeSpot(int x,int y, int i){
    //actually move the unit in their arrays
    unitC[i].locx=x;
    unitC[i].locy=y;
  }
}

/*public class soldiers extends army{
  //makes a constructor from army with certain properties:      
  public soldiers(int locx, int locy, int ar, int hp, int co){
    super(locx, locy, "soldier", ar, hp, co,5); //example of making a special unit using the army constructor
    
  }

} commented out for now while i figure this out*/