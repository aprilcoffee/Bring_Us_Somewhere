
//Camera Moving Variable
float camXX=0, camYY=0, camZZ=0;
float camX=0, camY=0, camZ=0;


ArrayList<Building> buildings;
PImage img1;
PImage img2;
int globalBoxWidth = 150;

int k = 0;
void setup() {
  size(1920, 1080, P3D);
  //fullScreen(P3D, 2);
  audioSetup();
  shaderInit();
  img1 = loadImage("texture/house_test.jpg");
  img2 = loadImage("texture/house_test2.jpg");

  buildings = new ArrayList<Building>();

  int _counter=0;
  for (int t=-5; t<5; t++) {
    for (int z=-5; z<5; z++) {
      buildings.add(new Building(
        new PVector(-globalBoxWidth*t, -globalBoxWidth*k +200, globalBoxWidth*z)
        ));
    }
  }
  k++;
  frameRate(30);
}
void draw() {
  background(0);
  //hint(DISABLE_DEPTH_TEST);
  soundCheck();
  float fc = float(frameCount);

  camera(1000, -600, 1500, 0, 0, 0, 0, 1, 0);

  //lightFalloff(1.0, 0.001, 0.0);
  //pointLight(100, 250, 150, 50, 50, 50);
  //lights();

  //blendMode(ADD);
  pushMatrix();
  rectMode(CENTER);
  //rotateY(radians(45));
  rotateX(-HALF_PI);
  fill(30);
  noStroke();
  //rect(0, 0, 2000, 1000);
  rectMode(CORNER);
  popMatrix();

  int _counter=0;

  //vector

  if (frameCount%100==0) {
    println("hi");
    for (int t=-5; t<5; t++) {
      for (int z=-5; z<5; z++) {
        buildings.add(new Building(
          new PVector(-globalBoxWidth*t, -globalBoxWidth*k +200, z*globalBoxWidth)
          ));
      }
    }
    k++;
  }

  for (int s=0; s<buildings.size(); s++) {
    Building B = buildings.get(s);
    B.build();

    //  B.generateBox();
  }

  //if (volume_Bass>0.5) {


  //.toon()

  //    //.blur(30, 10)
  //    .compose();
  //} else {

  blendMode(BLEND);
  fx.render()
    .sobel()
    .bloom(0.1, 10, 20)
    .blur(20, 0.1)
    //.toon()
    .brightPass(0.1)
    //.blur(30, 10)
    .compose();
  blendMode(BLEND);


  println(str(frameRate));
}
