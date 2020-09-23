
//Camera Moving Variable
float camXX=0, camYY=0, camZZ=0;
float camX=0, camY=0, camZ=0;


ArrayList<Building> buildings;

void setup() {
  size(1920, 1080, P3D);
  //fullScreen(P3D, 2);
  audioSetup();
  shaderInit();

  buildings = new ArrayList<Building>();

  int _counter=0;
  for (int a=0; a<360; a+=15) {
    for (int t=0; t<360; t+=15) {
      buildings.add(new Building(
        new PVector(0, 0, 0)
        ));
    }
  }
}
void draw() {
  background(0);

  soundCheck();
  float fc = float(frameCount);

  camera(-1000, -400, 1000, 0, 0, 0, 0, 1, 0);

  lightFalloff(1.0, 0.001, 0.0);
  pointLight(100, 250, 150, 50, 50, 50);
  lights();

  blendMode(ADD);
  pushMatrix();
  rectMode(CENTER);
  //rotateY(radians(45));
  rotateX(-HALF_PI);
  fill(30);
  noStroke();
  rect(0, 0, 2000, 1000);
  rectMode(CORNER);
  popMatrix();

  int _counter=0;

  //vector



  blendMode(ADD);
  if (volume_Bass>0.5) {
    fx.render()
      .sobel()
      .bloom(0.1, 3, 20)
      .blur(20, 0.1)
      .sobel()
      //.toon()
      .brightPass(0.1)
      .blur(3, 0.1)

      //.blur(30, 10)
      .compose();
  } else {
    fx.render()
      .sobel()
      //.bloom(0.5, 10, 20)
      .blur(20, 0.1)
      //.toon()
      //.brightPass(0.1)
      //.blur(30, 10)
      .compose();
  }


  println(volume_Bass);
}
