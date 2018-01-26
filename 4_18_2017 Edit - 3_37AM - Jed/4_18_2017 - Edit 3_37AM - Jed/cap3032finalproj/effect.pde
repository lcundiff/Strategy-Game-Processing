class effect {
  //vars
  float al,x,y,x2,y2,str,size; //alpha,x1y1,x2y2,stroke,size
  float dx,dtrav; //horizontal speed,distance traveled
  int type;//self-explanatory
  //constructor
  effect(int X,int Y,int X2, int Y2, int t){
    al=255;
    if(t==0) {//moving projectile
      x=X;
      y=Y;
      x2=X2;
      dx=Y2;
      dtrav=0;
    }
    else if(t==1) {//expanding ellipse
      x=X;
      y=Y;
      size=1;
    }
    else if(t==2) {//MISS dialogue
      x=X;
      y=Y;
      x2=X;
      y2=Y-5;
      str=10;
    }
    else if(t==3) {//MISS projectile
      dtrav=0;
      x=X;
      y=Y;
      x2=X2;
      dx=Y2;
    }
    type = t;
  }
  //functions
  void drawEff(){
    if(type==0||type==3) {//draw projectile
      noStroke();
      fill(255,al);
      ellipse(x+dtrav,y,10,2);
    }
    else if(type==1){
      fill(0,0);
      strokeWeight(1);
      stroke(255,al);
      ellipseMode(CENTER);
      ellipse(x,y,size,size);
    }
    else if(type==2){
      fill(150,0,0,al);
      textAlign(CENTER,CENTER);
      text("X",x,y);
      text("MISS",x2,y2);
    }
  }
  void step(){
    if(type==1)al-=5;
    else if(type!=0&&type!=3) al-=6;
    
    if(type==0||type==3) dtrav+=dx;
    
    if(type==0 && abs(dtrav)>=x2) {//x2 is now distance to travel
      type=1;
      x=dtrav+x;
      size=1;
    }
    else if(type==3 && abs(dtrav)>=x2) {
      type=2;
      x=dtrav+x;
      x2=x;
      y2=y-5;
      str=10;
    }
    
    if(type==1) size+=1; //cause ellipse to expand 
    
    if(type==2) y2-=0.2; //cause "MISS" to rise
  }
}