import pallav.Matrix.Matrix;

static class Shapes3D {

  //https://www.mathsisfun.com/geometry/common-3d-shapes.html
  // http://eusebeia.dyndns.org/4d/platonic

  static float[][] rotX;
  static float[][] rotY;
  static float[][] rotZ;

  static void calcRot(PVector r) {
    rotX = new float[][]{
      {1, 0, 0}, 
      {0, cos(r.x), -sin(r.x)}, 
      {0, sin(r.x), cos(r.x)}
    };

    rotY = new float[][]{
      {cos(r.y), 0, sin(r.y)}, 
      {0, 1, 0}, 
      {-sin(r.y), 0, cos(r.y)}
    };

    rotZ = new float[][]{
      {cos(r.z), -sin(r.z), 0}, 
      {sin(r.z), cos(r.z), 0}, 
      {0, 0, 1}
    };
  }

  static float[][] toArray(PVector p) {
    return new float[][]{
      {p.x}, 
      {p.y}, 
      {p.z}
    };
  }

  static PVector toPVector(float[][] m) {
    return new PVector(m[0][0], m[1][0], m[2][0]);
  }
  
  // http://eusebeia.dyndns.org/4d/icosahedron
  public static ArrayList<PVector> icosahedron() {
    ArrayList<PVector> points = new ArrayList<PVector>();

    PVector p0 = new PVector(0, 0, 0);
    
    float phi = (1+sqrt(5))/2;

    PVector p1 = new PVector(0, 1, phi);
    PVector p2 = new PVector(0, 1, -phi);
    PVector p3 = new PVector(0, -1, -phi);
    PVector p4 = new PVector(0, -1, phi);
    
    PVector p5= new PVector(1, phi, 0);
    PVector p6 = new PVector(1, -phi, 0);
    PVector p7 = new PVector(-1, -phi, 0);
    PVector p8 = new PVector(-1, phi, 0);
    
    PVector p9 = new PVector(phi, 0, 1);
    PVector p10 = new PVector(-phi, 0, 1);
    PVector p11 = new PVector(-phi, 0, -1);
    PVector p12 = new PVector(phi, 0, -1);
    
    

    points.add(p0);
    points.add(p1);
    points.add(p2);
    points.add(p3);
    points.add(p4);
    points.add(p5);
    points.add(p6);
    points.add(p7);
    points.add(p8);
    points.add(p9);
    points.add(p10);
    points.add(p11);
    points.add(p12);

    return points;
  }
  
  // https://en.wikipedia.org/wiki/Regular_icosahedron
  public static DefaultUndirectedGraph<PVector, DefaultEdge> icosahedronGraph(int s, PVector t, PVector r) {
    ArrayList<PVector> p = icosahedron();

    DefaultUndirectedGraph<PVector, DefaultEdge> g = new DefaultUndirectedGraph<PVector, DefaultEdge>(DefaultEdge.class);

    calcRot(r);
    for (PVector ps : p) {
      ps.set(toPVector(Matrix.Multiply(rotX, toArray(ps))));
      ps.set(toPVector(Matrix.Multiply(rotY, toArray(ps))));
      ps.set(toPVector(Matrix.Multiply(rotZ, toArray(ps))));
      ps.mult(s/2).add(t);
      g.addVertex(ps);
    }
    
    g.addEdge(p.get(0), p.get(1));
    g.addEdge(p.get(0), p.get(2));
    g.addEdge(p.get(0), p.get(3));
    g.addEdge(p.get(0), p.get(4));
    g.addEdge(p.get(0), p.get(5));
    g.addEdge(p.get(0), p.get(6));
    g.addEdge(p.get(0), p.get(7));
    g.addEdge(p.get(0), p.get(8));
    g.addEdge(p.get(0), p.get(9));
    g.addEdge(p.get(0), p.get(10));
    g.addEdge(p.get(0), p.get(11));
    g.addEdge(p.get(0), p.get(12));
    
    g.addEdge(p.get(1), p.get(4));
    g.addEdge(p.get(1), p.get(4));
    g.addEdge(p.get(1), p.get(4));
    
    g.addEdge(p.get(1), p.get(4));
    g.addEdge(p.get(1), p.get(5));
    g.addEdge(p.get(1), p.get(8));
    g.addEdge(p.get(1), p.get(9));
    g.addEdge(p.get(1), p.get(10));
    
    g.addEdge(p.get(2), p.get(3));
    g.addEdge(p.get(2), p.get(5));
    g.addEdge(p.get(2), p.get(8));
    g.addEdge(p.get(2), p.get(11));
    g.addEdge(p.get(2), p.get(12));
    
    g.addEdge(p.get(3), p.get(2));
    g.addEdge(p.get(3), p.get(6));
    g.addEdge(p.get(3), p.get(7));
    g.addEdge(p.get(3), p.get(11));
    g.addEdge(p.get(3), p.get(12));
    
    g.addEdge(p.get(4), p.get(1));
    g.addEdge(p.get(4), p.get(6));
    g.addEdge(p.get(4), p.get(7));
    g.addEdge(p.get(4), p.get(9));
    g.addEdge(p.get(4), p.get(10));
    
    g.addEdge(p.get(5), p.get(1));
    g.addEdge(p.get(5), p.get(2));
    g.addEdge(p.get(5), p.get(8));
    g.addEdge(p.get(5), p.get(9));
    g.addEdge(p.get(5), p.get(12));
    
    g.addEdge(p.get(6), p.get(3));
    g.addEdge(p.get(6), p.get(4));
    g.addEdge(p.get(6), p.get(7));
    g.addEdge(p.get(6), p.get(9));
    g.addEdge(p.get(6), p.get(12));
    
    g.addEdge(p.get(7), p.get(3));
    g.addEdge(p.get(7), p.get(4));
    g.addEdge(p.get(7), p.get(6));
    g.addEdge(p.get(7), p.get(10));
    g.addEdge(p.get(7), p.get(11));
    
    g.addEdge(p.get(8), p.get(1));
    g.addEdge(p.get(8), p.get(2));
    g.addEdge(p.get(8), p.get(5));
    g.addEdge(p.get(8), p.get(10));
    g.addEdge(p.get(8), p.get(11));
    
    g.addEdge(p.get(9), p.get(1));
    g.addEdge(p.get(9), p.get(4));
    g.addEdge(p.get(9), p.get(5));
    g.addEdge(p.get(9), p.get(6));
    g.addEdge(p.get(9), p.get(12));
    
    g.addEdge(p.get(10), p.get(1));
    g.addEdge(p.get(10), p.get(4));
    g.addEdge(p.get(10), p.get(7));
    g.addEdge(p.get(10), p.get(8));
    g.addEdge(p.get(10), p.get(11));
    
    g.addEdge(p.get(11), p.get(2));
    g.addEdge(p.get(11), p.get(3));
    g.addEdge(p.get(11), p.get(7));
    g.addEdge(p.get(11), p.get(8));
    g.addEdge(p.get(11), p.get(10));
    
    g.addEdge(p.get(12), p.get(2));
    g.addEdge(p.get(12), p.get(3));
    g.addEdge(p.get(12), p.get(5));
    g.addEdge(p.get(12), p.get(6));
    g.addEdge(p.get(12), p.get(9));
    
    



    return g;
  }

  public static ArrayList<PVector> cube() {
    ArrayList<PVector> points = new ArrayList<PVector>();

    PVector p0 = new PVector(0, 0, 0);

    PVector p1 = new PVector(-1, -1, 1);
    PVector p2 = new PVector(1, -1, 1);
    PVector p3 = new PVector(1, 1, 1);
    PVector p4 = new PVector(-1, 1, 1);

    PVector p5 = new PVector(-1, -1, -1);
    PVector p6 = new PVector(1, -1, -1);
    PVector p7 = new PVector(1, 1, -1);
    PVector p8 = new PVector(-1, 1, -1);

    points.add(p0);
    points.add(p1);
    points.add(p2);
    points.add(p3);
    points.add(p4);
    points.add(p5);
    points.add(p6);
    points.add(p7);
    points.add(p8);

    return points;
  }

  public static DefaultUndirectedGraph<PVector, DefaultEdge> cubeGraph(int s, PVector t, PVector r) {
    ArrayList<PVector> p = cube();

    DefaultUndirectedGraph<PVector, DefaultEdge> g = new DefaultUndirectedGraph<PVector, DefaultEdge>(DefaultEdge.class);

    calcRot(r);
    for (PVector ps : p) {
      ps.set(toPVector(Matrix.Multiply(rotX, toArray(ps))));
      ps.set(toPVector(Matrix.Multiply(rotY, toArray(ps))));
      ps.set(toPVector(Matrix.Multiply(rotZ, toArray(ps))));
      ps.mult(s/2).add(t);
      g.addVertex(ps);
    }

    g.addEdge(p.get(0), p.get(1));
    g.addEdge(p.get(0), p.get(2));
    g.addEdge(p.get(0), p.get(3));
    g.addEdge(p.get(0), p.get(4));
    g.addEdge(p.get(0), p.get(5));
    g.addEdge(p.get(0), p.get(6));
    g.addEdge(p.get(0), p.get(7));
    g.addEdge(p.get(0), p.get(8));

    g.addEdge(p.get(1), p.get(2));
    g.addEdge(p.get(2), p.get(3));
    g.addEdge(p.get(3), p.get(4));
    g.addEdge(p.get(4), p.get(1));

    g.addEdge(p.get(5), p.get(6));
    g.addEdge(p.get(6), p.get(7));
    g.addEdge(p.get(7), p.get(8));
    g.addEdge(p.get(8), p.get(5));

    g.addEdge(p.get(1), p.get(5));
    g.addEdge(p.get(2), p.get(6));
    g.addEdge(p.get(3), p.get(7));
    g.addEdge(p.get(4), p.get(8));


    return g;
  }

  public static ArrayList<PVector> tetrahydron() {
    ArrayList<PVector> points = new ArrayList<PVector>();

    PVector p1 = new PVector(1, -1/sqrt(3), -1/sqrt(6));
    PVector p2 = new PVector(-1, -1/sqrt(3), -1/sqrt(6));
    PVector p3 = new PVector(0, 2/sqrt(3), -1/sqrt(6));
    PVector p4 = new PVector(0, 0, 3/sqrt(6));

    PVector p0 = new PVector(0, 0, 0);

    points.add(p0);
    points.add(p1);
    points.add(p2);
    points.add(p3);
    points.add(p4);

    return points;
  }

  public static DefaultUndirectedGraph<PVector, DefaultEdge> tetrahydronGraph(int s, PVector t, PVector r) {
    ArrayList<PVector> p = tetrahydron();

    DefaultUndirectedGraph<PVector, DefaultEdge> g = new DefaultUndirectedGraph<PVector, DefaultEdge>(DefaultEdge.class);

    calcRot(r);
    for (PVector ps : p) {
      ps.set(toPVector(Matrix.Multiply(rotX, toArray(ps))));
      ps.set(toPVector(Matrix.Multiply(rotY, toArray(ps))));
      ps.set(toPVector(Matrix.Multiply(rotZ, toArray(ps))));
      ps.mult(s/2).add(t);
      g.addVertex(ps);
    }

    g.addEdge(p.get(1), p.get(2));
    g.addEdge(p.get(2), p.get(3));
    g.addEdge(p.get(3), p.get(1));

    g.addEdge(p.get(1), p.get(4));
    g.addEdge(p.get(2), p.get(4));
    g.addEdge(p.get(3), p.get(4));

    g.addEdge(p.get(0), p.get(1));
    g.addEdge(p.get(0), p.get(2));
    g.addEdge(p.get(0), p.get(3));
    g.addEdge(p.get(0), p.get(4));

    return g;
  }

  //http://eusebeia.dyndns.org/4d/prism3
  //void generatePrism() {
  //  PVector p1 = new PVector(-1, -1/sqrt(3), 1);
  //  PVector p2 = new PVector(1, -1/sqrt(3), 1);
  //  PVector p3 = new PVector(0, 2/sqrt(3), 1);

  //  PVector p4 = new PVector(-1, -1/sqrt(3), -1);
  //  PVector p5 = new PVector(1, -1/sqrt(3), -1);
  //  PVector p6 = new PVector(0, 2/sqrt(3), -1);

  //  g.addVertex(p1);
  //  g.addVertex(p2);
  //  g.addVertex(p3);
  //  g.addVertex(p4);
  //  g.addVertex(p5);
  //  g.addVertex(p6);

  //  g.addEdge(p1, p2);
  //  g.addEdge(p2, p3);
  //  g.addEdge(p3, p1);

  //  g.addEdge(p4, p5);
  //  g.addEdge(p5, p6);
  //  g.addEdge(p6, p4);

  //  g.addEdge(p1, p4);
  //  g.addEdge(p2, p5);
  //  g.addEdge(p3, p6);

  //  startingNodes.add(p1);
  //  startingNodes.add(p2);
  //  startingNodes.add(p3);
  //  startingNodes.add(p4);
  //  startingNodes.add(p5);
  //  startingNodes.add(p6);

  //  planeRadius = w/3.5;
  //  forceMultiplier = .1;
  //}
}
