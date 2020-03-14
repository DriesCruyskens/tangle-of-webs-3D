import java.awt.Color;

class Renderer {
  float scale = .62;
  PVector cam = new PVector(0, 0, scale);
  float focusDist = 1390;

  float exp = 1.;
  float dofsphere = .02;

  float alpha = .1;
  int nDots = 10;

  int colour;
  
  boolean dev = true;

  PVector p1, p2, v, o;
  float d, r, edgeL;
  
  PVector translate = new PVector(0, 0, 0);
  float rx = .99, ry = 3.11, rz = 0.62;
  PVector rotate = new PVector(rx, ry, rz);

  PVector center = new PVector(width/2, height/2, 0);
  
  float hs = 1.7, he = -7, ss = 40, se = .6, rr, hueStart, x, hue, sat;
  int rgb;
  
  Random gen = new Random();

  DefaultUndirectedGraph<PVector, DefaultEdge> g;

  Renderer(Web web) {
    this.g = web.g;
    stroke(255, 255, 255);
    colour = color(255, 255, 255);
  }

  void render() {
    loadPixels();
    for (DefaultEdge e : g.edgeSet()) {
      p1 = g.getEdgeSource(e).copy();
      p2 = g.getEdgeTarget(e).copy();
      
      rotate = new PVector(rx, ry, rz);
      Shapes3D.calcRot(rotate);
      p1.set(Shapes3D.toPVector(Matrix.Multiply(Shapes3D.rotX, Shapes3D.toArray(p1))));
      p1.set(Shapes3D.toPVector(Matrix.Multiply(Shapes3D.rotY, Shapes3D.toArray(p1))));
      p1.set(Shapes3D.toPVector(Matrix.Multiply(Shapes3D.rotZ, Shapes3D.toArray(p1))));
      
      p2.set(Shapes3D.toPVector(Matrix.Multiply(Shapes3D.rotX, Shapes3D.toArray(p2))));
      p2.set(Shapes3D.toPVector(Matrix.Multiply(Shapes3D.rotY, Shapes3D.toArray(p2))));
      p2.set(Shapes3D.toPVector(Matrix.Multiply(Shapes3D.rotZ, Shapes3D.toArray(p2))));
      
      p1.mult(scale).add(center);
      p2.mult(scale).add(center);
      if (dev) {
        line(p1.x, p1.y, p2.x, p2.y);
      } else {
      edgeL= PVector.dist(p1, p2) * nDots; // * 10 
      for (int i = 0; i < edgeL; i++) {
        // Select a point, v = lerp(a, b, rnd()), on l.
        v = PVector.lerp(p1, p2, gen.nextFloat());
     
        if (v.x > 0 && v.x < width && v.y > 0 && v.y < height) {
          //Calculate the distance, d = dst(v, c).
          d = PVector.dist(v, cam);
          //Find the sample radius, r = m * pow(abs(f - d), e).
          r = dofsphere * pow(abs(focusDist - d), exp);
          //find the new position, w = v + rndSphere(r).
          //rndSphere(v, r);
          o = rndSphere2D(r);
          
          x = cross(PVector.sub(v, center).normalize(), o);
          
          v.add(o);
          
          rr = pow(abs(x) / hs, he);
          
          if (x<0) {
            hueStart = 0.5;
          } else {
            hueStart = 0.833;
          }
          
          hue = constrain(hueStart + rr, 0, 1);
          
          sat = constrain(pow(abs(x)/ss, se), 0, 1);
          
          rgb = Color.HSBtoRGB(hue,sat,1);
          //Project w into 2D, and draw a pixel/dot.
          if (v.x > 0 && v.x < width && v.y > 0 && v.y < height) {
            int p = pixels[floor(v.y) * pixelWidth + floor(v.x)];
            pixels[floor(v.y) * pixelWidth + floor(v.x)] = blend(p, rgb, alpha);
          }
        }
      }}
    }
    updatePixels();
  }
  
  PVector rndSphere2D(float r) {
    PVector p1 = new PVector((float)gen.nextGaussian(), 
      (float)gen.nextGaussian()); 
    return p1.mult(r);
  }
  
  float cross(PVector a, PVector b) {
    return a.x * b.y - a.y * b.x;
  }

  void rndSphere(PVector p, float r) {
    PVector p1 = new PVector(map(gen.nextFloat(), 0, 1, -1, 1), 
      map(gen.nextFloat(), 0, 1, -1, 1), 
      map(gen.nextFloat(), 0, 1, -1, 1)); 
    p.add(p1.normalize().mult(r));
  }

  int blend (int a, int b, float ratio) {
    if (ratio > 1f) {
      ratio = 1f;
    } else if (ratio < 0f) {
      ratio = 0f;
    }

    int aA = a >>> 24;
    int aR = ((a & 0xff0000) >> 16);
    int aG = ((a & 0xff00) >> 8);
    int aB = (a & 0xff);

    int bA = b >>> 24;
    int bR = ((b & 0xff0000) >> 16);
    int bG = ((b & 0xff00) >> 8);
    int bB = (b & 0xff);

    int A = (int) (aA + (bA - aA) * ratio);
    int R = (int) (aR + (bR - aR) * ratio);
    int B = (int) (aB + (bB - aB) * ratio);
    int G = (int) (aG + (bG - aG) * ratio);

    return A << 24 | R << 16 | G << 8 | B;
  }

  //void renderDev() {
  //  for (DefaultEdge e : g.edgeSet()) {
  //    PVector p1 = g.getEdgeSource(e);
  //    PVector p2 = g.getEdgeTarget(e);

  //    stroke(255);
  //    fill(255);
  //    line(p1.x, p1.y, p1.z, p2.x, p2.y, p2.z);
  //  }

  //  pushMatrix();
  //  stroke(#00FF00);
  //  noFill();
  //  PVector p = c.p.copy();
  //  translate(p.x, p.y, p.z);
  //  sphere(5);
  //  popMatrix();

  //  pushMatrix();
  //  stroke(#0000FF);
  //  p = p.copy().add(c.n.copy().mult(100));
  //  translate(p.x, p.y, p.z);
  //  popMatrix();

  //  stroke(#00FF00);
  //  line(c.p.x, c.p.y, c.p.z, p.x, p.y, p.z);

  //  for (PVector pi : intersectMap.keySet()) {

  //    pushMatrix();
  //    println(pi);
  //    fill(#FF0000);
  //    stroke(#FF0000);
  //    pi = pi.copy();
  //    translate(pi.x, pi.y, pi.z);
  //    sphere(5);

  //    popMatrix();
  //  }
  //}
}
