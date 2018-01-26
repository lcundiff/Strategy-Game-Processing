class tile {
  //variables: defense value, movement penalty, name
  //all tile graphics will have 64*64 resolution, map display will show 6 rows of tiles with 10 tiles per row
  int def,mPen; // defense variable and movement penalty, used for movement calculations 
  String type;
  color cl,tempC; 
  boolean move;
  int x,y;
  PImage graphic;
  //constructor
  tile(color c, int tx,int ty) {
    move=false;
    cl = c;
    x=tx;
    y=ty;
    /*if(c=burgundy){
      def=3;
      mPen=1;
      type="RED FACTORY";
      //graphic=image("factoryRed.png");
    }*/
    if(c==grass){
      def=1;
      mPen=1;
      type="PLAINS";
    }
    if(c==path){
      def=0; // no defense 
      mPen=1; // 
      type="ROAD";
    }
    if(c==mtn){
      def=3; // high defense
      mPen=3;
      type="MOUNTAIN";
    }
    if(c==forest){
      def=2;
      mPen=2;
      type="WOODS";
    }
    if(c==city){
      def=3;
      mPen=1;
      type="CITY";
    }
    /*naval units will calculate move distances and defense bonuses negatively
    so that land units can read the movement penalty as out of bounds and
    not be able to move onto water*/
    if(c==water){
      def=-1; // used to identify that it is water. Most units cannot travel across
      mPen=5; //for now, no units can travel on water, ships won't be possible
      type="WATER";
    }
  }
  //functions
  
}