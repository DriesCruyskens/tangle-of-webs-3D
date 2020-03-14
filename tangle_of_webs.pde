import controlP5.*;
import processing.svg.*;
import peasy.*;

//PeasyCam cam;
Renderer r;

ControlP5 cp5;
Web web;
boolean record;

void setup() {
  pixelDensity(1);
  size(1748, 1748, P2D);
  //noSmooth();
  reset();
  
  //cam = new PeasyCam(this, 0, 0, 0, 2000);
  for (int j = 0; j < 15000; j++) {
    web.generateEdge();
  }
  r = new Renderer(web);

  cp5 = new ControlP5(this);

  // change the default font to Verdana
  PFont p = createFont("Verdana", 20); 
  ControlFont font = new ControlFont(p);
  cp5.setFont(font);

  cp5.addSlider("exp")
    .setPosition(10, 10)
    .setRange(0, 2)
    .setSize(300, 30)
    .setValue(.8)
    .plugTo(r);

  cp5.addSlider("dofsphere")
    .setPosition(10, 50)
    .setRange(0, 1)
    .setSize(300, 30)
    .setValue(.2)    
    .plugTo(r);

  cp5.addSlider("focusDist")
    .setPosition(10, 80)
    .setRange(0, 4000)
    .setSize(300, 30)
    .setValue(3280)
    .plugTo(r);
    
   cp5.addSlider("alpha")
    .setPosition(10, 120)
    .setRange(0, 1)
    .setSize(300, 30)
    .setValue(.1)
    .plugTo(r);
    
    cp5.addSlider("nDots")
    .setPosition(10, 160)
    .setRange(0, 100)
    .setSize(300, 30)
    .setValue(10)
    .plugTo(r);
    
    cp5.addSlider("rx")
    .setPosition(10, 200)
    .setRange(0, PI)
    .setSize(300, 30)
    .setValue(3.14)
    .plugTo(r);
    
    cp5.addSlider("ry")
    .setPosition(10, 240)
    .setRange(0, PI)
    .setSize(300, 30)
    .setValue(2.35)
    .plugTo(r);
    
    cp5.addSlider("rz")
    .setPosition(10, 280)
    .setRange(0, PI)
    .setSize(300, 30)
    .setValue(0.55)
    .plugTo(r);
    
    cp5.addSlider("scale")
    .setPosition(10, 320)
    .setRange(0, 3)
    .setSize(300, 30)
    .setValue(1)
    .plugTo(r);
    
    cp5.addSlider("hs")
    .setPosition(10, 360)
    .setRange(-20, 20)
    .setSize(300, 30)
    .setValue(1.73)
    .plugTo(r);
    
    cp5.addSlider("he")
    .setPosition(10, 400)
    .setRange(-20, 20)
    .setSize(300, 30)
    .setValue(-7.8)
    .plugTo(r);
    
    cp5.addSlider("ss")
    .setPosition(10, 440)
    .setRange(-20, 50)
    .setSize(300, 30)
    .setValue(43)
    .plugTo(r);
    
    cp5.addSlider("se")
    .setPosition(10, 480)
    .setRange(-20, 50)
    .setSize(300, 30)
    .setValue(1.7)
    .plugTo(r);

  cp5.addToggle("dev")
    .setPosition(10, 520)
    .plugTo(r)
    .setValue(true);
    //.setSize(40, 40).setMode(ControlP5.SWITCH)
    ;
}

void reset() {
  web = new Web();
}

void draw() {
  
  pushMatrix();
  //translate(width/2, height/2);
  //background(#071013);
  background(20);
  r.render();
  popMatrix();
  
  //noLoop();
}

void keyPressed() {
  if (key == ' ') {
    reset();
  }
  if (keyCode == RIGHT) {
    for (int j = 0; j < 200; j++) {
      web.generateEdge();
      
    }
    r.g = web.g;
  }
  if (key == 's') {
    String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
    save("prints/"+ timestamp + ".tif");
  }
}
