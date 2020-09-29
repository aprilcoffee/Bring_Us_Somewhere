class Building {
  ArrayList<Fragment> fragments;

  PVector pos;
  PVector vel;
  PVector acc;
  int type;
  float l = globalBoxWidth/2;

  PImage img;
  int buildStage = 4;
  int houseNum = 0;

  //Ani[] buildAni = new Ani[3]; //3 step ani
  Ani buildAni;
  float ani1 = 0;
  float ani2 = 0;  
  float ani3 = 0;

  float tin = 0; 
  Building(int _n, PVector _pos) {
    houseNum = _n;
    if (random(2)>1) {
      img = img1;
    } else {
      img = img2;
    }
    img = img2;

    pos = _pos.copy();
    buildAni = new Ani(this, random(1, 3), 0.1, "ani1", 2*l, Ani.EXPO_IN, "onEnd:aniEnd");    
    buildAni.setPlayMode(Ani.FORWARD);    

    fragments = new ArrayList<Fragment>();  
    buildBox();

    //Ani.to(this, 1.5, "ani", random(0,width), Ani.EXPO_IN_OUT);

    //(this, duration, step stay, variable, target, method, endcall)
    //buildAni[0] = new Ani(this, 1, 0.5, "ani", l, Ani.EXPO_IN_OUT, "onEnd:aniEnd");
    //buildAni[0].setPlayMode(Ani.FORWARD);

    //buildAni[0] = new Ani(this, 1, 0.5, "stage2", l, Ani.EXPO_IN_OUT, "onEnd:aniEnd");
    //buildAni[0].setPlayMode(Ani.FORWARD);

    //buildAni[0] = new Ani(this, 1, 0.5, "stage3", l, Ani.EXPO_IN_OUT, "onEnd:aniEnd");
    //buildAni[0].setPlayMode(Ani.FORWARD);
  }

  void aniEnd() {
    if (buildStage <= 3) {
      buildStage++;    
      //ani2 = 0;
      if (buildStage ==1) {
        buildAni = new Ani(this, random(1, 2), 0.1, "ani2", 2*l, Ani.EXPO_IN_OUT, "onEnd:aniEnd");
      } else if (buildStage ==2) {
        buildAni = new Ani(this, random(1, 2), 0.1, "ani3", 2*l, Ani.EXPO_IN_OUT, "onEnd:aniEnd");
      } else if (buildStage ==3 ) {
        buildAni = new Ani(this, random(2, 3), 0.1, "tin", 200, Ani.EXPO_IN_OUT, "onEnd:aniEnd");
      }
      buildAni.setPlayMode(Ani.FORWARD);  
      //buildAni = new Ani(this, 1, 0.5, "ani", 2*l, Ani.EXPO_IN_OUT, "onEnd:aniEnd");    
      //buildAni.seek(0);
      //buildAni.resume();
    }
  }
  void build() {

    pushMatrix();      
    translate(pos.x, pos.y, pos.z);
    stroke(255);

    switch(buildStage) {
    case 0:
      line(-l, l, l, -l, l + -ani1, l);
      line(-l, l, l, -l, l, l+ -ani1);
      line(-l, l, l, -l + ani1, l, l);
      break;
    case 1:
      line(-l, l, l, -l, -l, l);
      line(-l, l, l, -l, l, -l);
      line(-l, l, l, l, l, l);

      line(-l, -l, l, -l, -l, l + -ani2); //B->E
      line(-l, -l, l, -l + ani2, -l, l); //B->F

      line(-l, l, -l, -l, l + -ani2, -l); //C->E
      line(-l, l, -l, -l + ani2, l, -l); //C->G

      line(l, l, l, l, l+ -ani2, l); //D->F
      line(l, l, l, l, l, l + -ani2); //D->G
      break;
    case 2:

      line(-l, l, l, -l, -l, l);
      line(-l, l, l, -l, l, -l);
      line(-l, l, l, l, l, l);

      line(-l, -l, l, -l, -l, l + -ani2); //B->E
      line(-l, -l, l, -l + ani2, -l, l); //B->F

      line(-l, l, -l, -l, l + -ani2, -l); //C->E
      line(-l, l, -l, -l + ani2, l, -l); //C->G

      line(l, l, l, l, l+ -ani2, l); //D->F
      line(l, l, l, l, l, l + -ani2); //D->G


      line(-l, -l, -l, -l + ani3, -l, -l); //E->H
      line(l, -l, l, l, -l, l+-ani3);  //F->H
      line(l, l, -l, l, l + -ani3, -l); //G -> H

      break;
    case 3:
      //buildBox();

      hint(ENABLE_DEPTH_TEST);
      stroke(255);
      line(-l, l, l, -l, -l, l);
      line(-l, l, l, -l, l, -l);
      line(-l, l, l, l, l, l);

      line(-l, -l, l, -l, -l, l + -ani2); //B->E
      line(-l, -l, l, -l + ani2, -l, l); //B->F

      line(-l, l, -l, -l, l + -ani2, -l); //C->E
      line(-l, l, -l, -l + ani2, l, -l); //C->G

      line(l, l, l, l, l+ -ani2, l); //D->F
      line(l, l, l, l, l, l + -ani2); //D->G


      line(-l, -l, -l, -l + ani3, -l, -l);
      line(l, -l, l, l, -l, l+-ani3);
      line(l, l, -l, l, l + -ani3, -l);
      stroke(255);


      //group 1

      break;
    case 4:
      hint(ENABLE_DEPTH_TEST);
      for (int s=0; s<fragments.size(); s++) {
        Fragment F = fragments.get(s);
        F.update();
        F.show();
      }

      //generateBox();

      break;
    }
    popMatrix();
  }

  void generateBox() {

    //float boxLevel = boxLength/(boxLength*2);
    //PVector textureFront, textureTop, textureSide;
    //int coordination;

    //textureFront = PVector.div(eTextureFront, (boxLength*2));
    //textureTop = PVector.div(eTextureTop, (boxLength*2));
    //textureSide = PVector.div(eTextureSide, (boxLength*2));

    pushMatrix();
    translate(pos.x, pos.y, pos.z);
    textureMode(NORMAL);
    noStroke();

    // Z "front" face
    beginShape();
    texture(img);
    vertex( -l, -l, l, 0, 0);
    vertex( l, -l, l, 1, 0);
    vertex( l, l, l, 1, 1);
    vertex( -l, l, l, 0, 1);
    endShape();

    // Z "back" face
    beginShape();
    texture(img);
    vertex(-l, -l, -l, 0, 0);
    vertex( l, -l, -l, 1, 0);
    vertex( l, l, -l, 1, 1);
    vertex(-l, l, -l, 0, 1);
    endShape();

    // +Y "bottom" face
    beginShape();
    texture(img);
    vertex(-l, l, l, 0, 0);
    vertex( l, l, l, 1, 0);
    vertex( l, l, -l, 1, 1);
    vertex(-l, l, -l, 0, 1);
    endShape();

    // -Y "top" 
    beginShape();
    texture(img);
    vertex(-l, -l, l, 0, 0);
    vertex( l, -l, l, 1, 0);
    vertex( l, -l, -l, 1, 1);
    vertex(-l, -l, -l, 0, 1);
    endShape();

    // +X "right" face
    beginShape();
    texture(img);
    vertex( l, -l, l, 0, 0);
    vertex( l, -l, -l, 1, 0);
    vertex( l, l, -l, 1, 1);
    vertex( l, l, l, 0, 1);
    endShape();
    // -X "left" face
    beginShape();
    texture(img);
    vertex(-l, -l, l, 0, 0);
    vertex(-l, -l, -l, 1, 0);
    vertex(-l, l, -l, 1, 1);
    vertex(-l, l, l, 0, 1);
    endShape();

    popMatrix();
  }
  void update() {
  }

  void show() {
  }
  void collapse() {
  }
  void buildBox() {

    float fragmentSize = 10;
    float f = 2*l/fragmentSize;
    float c = l;

    int _x = 0;
    int _y = 0;
    for (float b=-l; b<l; b+=f) {
      _x = 0;
      for (float a=-l; a<l; a+=f) {

        c = l;
        // Z 'front'
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          0, 
          new PVector(a, b, c), 
          f, 
          l, 
          img
          ));

        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          1, 
          new PVector(a+f, b+f, c), 
          f, 
          l, 
          img
          ));


        c = -l;
        // Z 'back'
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          0, 
          new PVector(a, b, c), 
          f, 
          l, 
          img
          ));

        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          1, 
          new PVector(a+f, b+f, c), 
          f, 
          l, 
          img
          ));  



        // +Y "bottom" face
        c = l;
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          2, 
          new PVector(a, c, b), 
          f, 
          l, 
          img
          ));
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          3, 
          new PVector(a+f, c, b+f), 
          f, 
          l, 
          img
          ));  


        //-Y "top" face
        c = -l;
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          2, 
          new PVector(a, c, b), 
          f, 
          l, 
          img
          ));
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          3, 
          new PVector(a+f, c, b+f), 
          f, 
          l, 
          img
          )); 


        // +X "right" face
        c = l;
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          4, 
          new PVector(c, a, b), 
          f, 
          l, 
          img
          ));
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          5, 
          new PVector(c, a+f, b+f), 
          f, 
          l, 
          img
          ));  


        //-X "left" face
        c = -l;
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          4, 
          new PVector(c, a, b), 
          f, 
          l, 
          img
          ));
        fragments.add(new Fragment(houseNum, 
          _x, _y, 
          5, 
          new PVector(c, a+f, b+f), 
          f, 
          l, 
          img
          )); 


        _x++;
      }
      _y++;
    }
  }
}

class Fragment {
  int mode; //0 = up, 1 = down
  PVector loc;
  PVector origin_loc;
  float f;
  float l;
  PImage img;
  int num_x;
  int num_y;

  float r = 1;
  PVector add;
  float text = 0;
  Ani textureAni;
  int houseNum;
  Fragment(int _num, int _x, int _y, int _mode, PVector _loc, float _f, float _l, PImage _img) {

    houseNum = _num;
    num_x = _x;
    num_y = _y;
    mode = _mode; 
    loc = _loc.copy();
    origin_loc = loc.copy();
    f = _f;
    l = _l;
    img = _img;    
    add = origin_loc.copy().div(50).add(PVector.random3D().div(1));
    if (houseNum == 1) {
      textureAni = new Ani(this, 0, 2, "text", 100, Ani.QUART_IN_OUT, "onEnd:newEnd");
    } else {
      textureAni = new Ani(this, 0, 6, "text", 100, Ani.QUART_IN_OUT, "onEnd:newEnd");
    }
    textureAni.setPlayMode(Ani.FORWARD);
  }
  void aniEnd() {
    textureAni = new Ani(this, 1, 2, "r", 1, Ani.ELASTIC_IN_OUT, "onEnd:newEnd");
  }
  void newEnd() {
    textureAni = new Ani(this, 1.5, 2.5, "r", random(50, 100), Ani.ELASTIC_IN_OUT, "onEnd:aniEnd");
  }
  void update() {
    trigger = r;
    //loc = origin_loc.copy();

    //r = 100*cos(radians(frameCount*3))*sin(radians(frameCount));
    //r = 1;
    if (abs(r - 1) < 0.1) {
      loc = origin_loc.copy();
    } else {
      loc = origin_loc.copy().add(add.copy().mult(r));
    }
    // loc = origin_loc.copy();
  }
  void show() {
    noFill();
    noStroke();
    //stroke(255,0,0);
    textureMode(NORMAL);
    if (mode==0) {
      beginShape();
      texture(img);
      vertex(loc.x, loc.y, loc.z, fixTexture(origin_loc.x), fixTexture(origin_loc.y));
      vertex(loc.x+f, loc.y, loc.z, fixTexture(origin_loc.x+f), fixTexture(origin_loc.y));
      vertex(loc.x, loc.y+f, loc.z, fixTexture(origin_loc.x), fixTexture(origin_loc.y+f));
      endShape(CLOSE);
    } else if (mode==1) {
      beginShape();
      texture(img);
      vertex(loc.x, loc.y, loc.z, fixTexture(origin_loc.x), fixTexture(origin_loc.y));
      vertex(loc.x-f, loc.y, loc.z, fixTexture(origin_loc.x-f), fixTexture(origin_loc.y));
      vertex(loc.x, loc.y-f, loc.z, fixTexture(origin_loc.x), fixTexture(origin_loc.y-f));
      endShape(CLOSE);
    } else if (mode==2) {
      beginShape();
      texture(img);
      vertex(loc.x, loc.y, loc.z, fixTexture(origin_loc.x), fixTexture(origin_loc.z));
      vertex(loc.x+f, loc.y, loc.z, fixTexture(origin_loc.x+f), fixTexture(origin_loc.z));
      vertex(loc.x, loc.y, loc.z+f, fixTexture(origin_loc.x), fixTexture(origin_loc.z+f));
      endShape(CLOSE);
    } else if (mode==3) {
      beginShape();
      texture(img);
      vertex(loc.x, loc.y, loc.z, fixTexture(origin_loc.x), fixTexture(origin_loc.z));
      vertex(loc.x-f, loc.y, loc.z, fixTexture(origin_loc.x-f), fixTexture(origin_loc.z));
      vertex(loc.x, loc.y, loc.z-f, fixTexture(origin_loc.x), fixTexture(origin_loc.z-f));
      endShape(CLOSE);
    } else if (mode==4) {
      beginShape();
      texture(img);
      vertex(loc.x, loc.y, loc.z, fixTexture(origin_loc.y), fixTexture(origin_loc.z));
      vertex(loc.x, loc.y+f, loc.z, fixTexture(origin_loc.y+f), fixTexture(origin_loc.z));
      vertex(loc.x, loc.y, loc.z+f, fixTexture(origin_loc.y), fixTexture(origin_loc.z+f));
      endShape(CLOSE);
    } else if (mode==5) {
      beginShape();
      texture(img);
      vertex(loc.x, loc.y, loc.z, fixTexture(origin_loc.y), fixTexture(origin_loc.z));
      vertex(loc.x, loc.y-f, loc.z, fixTexture(origin_loc.y-f), fixTexture(origin_loc.z));
      vertex(loc.x, loc.y, loc.z-f, fixTexture(origin_loc.y), fixTexture(origin_loc.z-f));
      endShape(CLOSE);
    }
  }
  float fixTexture(float _temp) {
    return map(_temp, -l, l, 0, 1);
  }
  float fixTexture_x(float _temp) {
    return map(_temp, l, -l, 0, 1);
  }
}
