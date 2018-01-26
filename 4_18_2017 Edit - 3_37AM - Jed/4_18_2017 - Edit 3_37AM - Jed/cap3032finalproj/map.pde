class map {
  //variables: width, height (in tiles), tile array
  int w,h;
  tile[][] tileA;
  //constructor
  map(int wi, int he){
    w=wi;
    h=he;
    tileA = new tile[wi][he];
  }
  //functions
  void addOcc(army a, int x, int y) {
    
  }
  int getOcc(int x, int y, ArrayList<army> A) {
    int b = -1;
    for(int i = 0; i < A.size(); i++){
      if(A.get(i).locx == x && A.get(i).locy == y) {
        b=i;
      }
    }
    return b;
  }
}