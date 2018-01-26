// global variables
boolean attacking = false; 

// will be the super class for units
public class unit {
  boolean hit = false ; // has the structure been hit
  bTile tile; 
  String type; 
  int HP; 
  int atkPower; 
  int locx, locy;
  // unit constructor
  public unit(int x, int y, String ty, int h, int a) {
    locx = x;
    locy = y; 
    type = ty;
    HP = h ; 
    atkPower = a;
  }
  public unit() {
    HP=0;
  }
  //functions
  public int fireMethod(bTile[][] a) {
    for (int i=3;i>=0; i--) {
      if (a[i][locy].live) {
        return (i+(locy*4));
      }
    }
    return -1;
  } // fire method
}

public class soldier extends unit {

  // makes a constructor from army with certain properties:      
  public soldier(int locx, int locy, int ar, int hp, int co, int r) {
    super(locx, locy, "soldier", hp, ar); //example of making a special unit using the army constructor

    // when game sets unit to attacking it triggers fire method with inputed values
    /*if(attacking == true){
     super.fireMethod(5); // shoots straight forward and damages the first enemy hit for 5 points
     } */
  }
}