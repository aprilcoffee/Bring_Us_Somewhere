import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ch.bildspur.postfx.builder.*; 
import ch.bildspur.postfx.pass.*; 
import ch.bildspur.postfx.*; 
import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class HsinChu_p5 extends PApplet {



//Shader PostFix



PostFX fx;

//Camera Moving Variable
float camXX=0, camYY=0, camZZ=0;
float camX=0, camY=0, camZ=0;

//Sound Analyze

AudioIn input;
Amplitude loudness;
FFT fft;
Waveform waveform;
int bands = 1024;
float smoothFactor = 0.5f;
float[] sum = new float[bands];
int scale = 5;
float barWidth;
float volume;
int currentBeat = 0;
float smoothingFactor = 0.25f;
float volume_MidHigh, volume_Mid, volume_High, volume_Low, volume_Bass, volume_Peak;


ArrayList<Particle> pt;
public void setup() {
  
  //fullScreen(P3D, 2);
  fx = new PostFX(this);
  pt = new ArrayList<Particle>();

  input = new AudioIn(this, 0);
  input.start();
  loudness = new Amplitude(this);
  loudness.input(input);
  barWidth = width/PApplet.parseFloat(bands);
  fft = new FFT(this, bands);
  fft.input(input);
  waveform = new Waveform(this, 1024);
  waveform.input(input);

  //Shader Post Fix init
  fx = new PostFX(this);
  frameRate(30);

  int _counter=0;
  for (int a=0; a<360; a+=15) {
    for (int t=0; t<360; t+=15) {
      pt.add(new Particle(a, t, 3, 3, _counter++, 500));
    }
  }
}
public void draw() {
  background(0);
  float fc = PApplet.parseFloat(frameCount);
  soundCheck();
  camera(-1000, -400, 1000, 0, 0, 0, 0, 1, 0);

  lightFalloff(1.0f, 0.001f, 0.0f);
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


  for (int a=0; a<360; a+=15) {
    for (int t=0; t<360; t+=15) {
      Particle P = pt.get(_counter++);
      P.va = 1.3f;
      P.vt = 0.98f;
      P.r = 400;
      P.update();
      //P.show();
    }
  }


  //for (int s=0; s<100; s++) {
  //  Particle P = pt.get(s);
  //}
  hint(DISABLE_DEPTH_TEST);
  for (int s=0; s<(_counter-1)/7; s++) {
    Particle P1 = pt.get(s);
    int try_num = 0;
    if (random(2)>1) {
      try_num=s+1+floor(abs(2*sin(radians(fc))));
    } else {
      try_num=s+(30*floor(abs(10*sin(radians(fc)))));
    }
    if (try_num>=_counter)continue;
    Particle P2 = pt.get(s+1);

    stroke(255, 100);
    strokeWeight(0.6f);
    line(P1.px, P1.py, P1.pz, P2.px, P2.py, P2.pz);
  }

  blendMode(ADD);
  if (volume_Bass>0.5f) {
    fx.render()
      .sobel()
      .bloom(0.1f, 3, 20)
      .blur(20, 0.1f)
      .sobel()
      //.toon()
      .brightPass(0.1f)
      .blur(3, 0.1f)

      //.blur(30, 10)
      .compose();
  } else {
    fx.render()
      .sobel()
      //.bloom(0.5, 10, 20)
      .blur(20, 0.1f)
      //.toon()
      //.brightPass(0.1)
      //.blur(30, 10)
      .compose();
  }


  println(volume_Bass);

  stroke(255);
  //ellipse(width/2, height/2, volume*1000, volume*1000);
}
class Particle {
  float px, py, pz;
  float a, t;
  float va, vt;
  float r;
  float num;
  Particle(float _a, float  _t, float _va, float _vt, float _num, float _r) {
    a=_a;
    t=_t;
    va=_va;
    vt=_vt;
    num = _num;
    r = _r;
  }
  public void update() {
    float _a = radians(a);
    float _t = radians(t);
    px = r*sin(_a*1.90f)*cos(_t*0.25f);
    py = r*sin(_t*0.87f)*sin(_a*2);
    pz = r*cos(_a*1.58f)*cos(_t*1.37f);

    a+=va;
    t+=vt;
  }
  public void show() {
    pushMatrix();
    translate(px, py, pz);
    fill(255, 200);
    noStroke();
    ellipse(0, 0, 0.2f, 1);
    popMatrix();
  }
}

public void soundCheck() {
  //background(0);
  waveform.analyze();


  volume_Bass = 0;

  volume_Low = 0;
  volume_Mid = 0;
  volume_MidHigh = 0;
  volume_High = 0;
  volume_Peak = 0;

  fft.analyze();
  input.amp(1);
  volume = loudness.analyze();
  //volume += (loudness.analyze() - sum) * smoothingFactor;
  volume*=1000;
  //println(volume);
  volume = norm(volume, 0, 50);
  //barWidth *= 100;
  float soundFlag = 1000;
  for (int i = 0; i < bands; i++) {
    // Smooth the FFT spectrum data by smoothing factor
    sum[i] += (fft.spectrum[i] - sum[i]) * smoothingFactor;

    if (i<=4)volume_Bass+=sum[i]*soundFlag;
    else if (i>4 && i<=8)volume_Low +=sum[i]*soundFlag;
    else if (i>8 && i<=23)volume_Mid +=sum[i]*soundFlag;
    else if (i>23 && i<=75)volume_MidHigh +=sum[i]*soundFlag;
    else if (i>75 && i<=190)volume_High+=sum[i]*soundFlag;
    else if (i>190 && i<= 650)volume_Peak+=sum[i]*soundFlag;
    //println(volume_Low);
    //fill(255);
    // Draw the rectangles, adjust their height using the scale factor
    //rect(i*barWidth, height, barWidth, -sum[i]*height*scale);
  }
  volume_Bass /= 4;
  volume_Low /= 4;
  volume_Mid /= 15;
  volume_MidHigh /= 52;
  volume_High /= 115;
  volume_Peak /= 400;

  volume_Bass = norm(volume_Bass, 0, 10);
  volume_Low = norm(volume_Low, 0, 25);
  volume_Mid = norm(volume_Mid, 0, 10);
  volume_MidHigh = norm(volume_MidHigh, 0, 3);
  volume_High = norm(volume_High, 0, 1);
  volume_Peak = norm(volume_Peak, 0, 1);

  //println(volume_Peak);
}
  public void settings() {  size(1920, 1080, P3D); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#080000", "--hide-stop", "HsinChu_p5" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
