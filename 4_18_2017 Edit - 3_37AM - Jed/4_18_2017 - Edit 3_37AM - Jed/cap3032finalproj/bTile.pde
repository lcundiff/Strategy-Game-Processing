public class bTile {
  //bTiles comprise the battleGrid and hold a single occupant, occ, that is either alive or dead
  //they may also have r and c (row,column) variables to determine where this particular unit is
  //vars
  unit occ;
  boolean live;
  int team,index;
  //constructor
  bTile(unit o,int i){
    if(o.HP>0) {
      live=true;
      index=i;
    }
    else live = false;
  }
  bTile(){
    live = false;
  }
  //functions
}