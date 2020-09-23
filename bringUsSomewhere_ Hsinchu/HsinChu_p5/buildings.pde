class Building {
  PVector pos;
  PVector vel;
  PVector acc;
  int type;
  float l = globalBoxWidth/2;

  PImage img;
  int buildStage = 0;

  //Ani[] buildAni = new Ani[3]; //3 step ani
  Ani buildAni;
  float ani1 = 0;
  float ani2 = 0;  
  float ani3 = 0;

  float tin = 0; 
  Building(PVector _pos) {
    if (random(2)>1) {
      img = img1;
    } else {
      img = img2;
    }

    pos = _pos;
    buildAni = new Ani(this, random(1, 3), 0.1, "ani1", 2*l, Ani.EXPO_IN, "onEnd:aniEnd");    
    buildAni.setPlayMode(Ani.FORWARD);    


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


      line(-l, -l, -l, -l + ani3, -l, -l);
      line(l, -l, l, l, -l, l+-ani3);
      line(l, l, -l, l, l + -ani3, -l);

      break;
    case 3:
      hint(DISABLE_DEPTH_TEST);
      textureMode(NORMAL);
      tint(255, tin);
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
      tint(255, 255);


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
      textureMode(NORMAL);
      tint(255, tin);
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
      tint(255, 255);

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
}
