import java.util.*;
import java.util.Arrays;
import org.jgrapht.Graphs;
import org.jgrapht.Graph;

class Web {
  // maybe implement own graph https://www.baeldung.com/java-graphs
  DefaultUndirectedGraph<PVector, DefaultEdge> g; //graph
  DefaultUndirectedGraph<PVector, DefaultEdge> gComplete;
  Plane c; // candidate line
  Map<PVector, DefaultEdge> intersectMap; // maps intersect points to the edge they are on
  ArrayList<PVector> startingNodes;
  List<PVector> hamiltonian;

  PVector translate = new PVector(0, 0, 0);
  PVector rotate = new PVector(0, 0, 0);
  int scale = 3000;
  
  float forceMultiplier = .5;
  float edgeLengthThresh = scale/20;
  float planeRadius = scale/6;

  Random gen = new Random();

  Web() {
    startingNodes = new ArrayList<PVector>();
    g = new DefaultUndirectedGraph<PVector, DefaultEdge>(DefaultEdge.class);
    //addCube(scale, translate, rotate);
    //addTetrahydron(scale, translate, rotate);
    addIcosahedron(scale, translate, rotate);
    c = new Plane(new PVector(0, 0), new PVector(0, 0));
    generateEdge();
  }

  void applyForce() {
    DefaultUndirectedGraph<PVector, DefaultEdge> newg = new DefaultUndirectedGraph<PVector, DefaultEdge>(DefaultEdge.class);

    // we need a map from old to new pvector because we need to reconstruct the edges after computation
    // jgrapht does not allow changing existing nodes/PVectors x and y values (sees is as a new node not in the graph)
    Map<PVector, PVector> oldNewPositions = new HashMap<PVector, PVector>();

    // calculate new pos for each vertex and map them to the old point
    for (PVector p : g.vertexSet()) {

      // leave startingnodes in place
      boolean isStartingNode = false;
      for (PVector startingNode : startingNodes) {
        if (p.x == startingNode.x && p.y == startingNode.y && p.z == startingNode.z) {
          isStartingNode = true;
        }
      }

      if (isStartingNode) {
        oldNewPositions.put(p, p);
        newg.addVertex(p);
        continue; // dont adjust starting nodes
      }

      // for all edges of a vertex: put their normalized directoin vector in a list
      ArrayList<PVector> vectorlist = new ArrayList<PVector>();

      for (DefaultEdge e : g.edgesOf(p)) {
        // for each edge: calculate normalized vector towards opposite node

        // direction = destination - source
        PVector direction = PVector.sub(Graphs.getOppositeVertex(g, e, p), p);
        // only keep sufficiently long
        if (direction.mag() > edgeLengthThresh) {
          direction.normalize();
          vectorlist.add(direction);
        }
      }

      PVector sum = new PVector(0, 0);
      // sum all the normalized vectors in the vectorlist
      try {
        sum.set(vectorlist.get(0));
      }
      catch(Exception e) {
      }

      for (int j = 1; j < vectorlist.size(); j++) {
        sum.add(vectorlist.get(j));
      }

      // amount of movement multiplier
      sum.mult(forceMultiplier);

      // calculate new vertex position, map old to new position and add new postition to the new graph
      oldNewPositions.put(p, PVector.add(p, sum));
      newg.addVertex(PVector.add(p, sum)); // doing this here and not in next block because adding edges requires all nodes to be present beforehand
    }

    // connect new nodes in new graph using the edges from the old graph
    for (Map.Entry<PVector, PVector> entry : oldNewPositions.entrySet()) {
      // connect the new positions to the correct new positioned neighbor vertices using the oldnewpositions map
      for (DefaultEdge e : g.edgesOf(entry.getKey())) {
        newg.addEdge(entry.getValue(), oldNewPositions.get(Graphs.getOppositeVertex(g, e, entry.getKey())));
      }
    }

    // replace the exisiting graph with the newly calculated one
    g = newg;
  }

  void generateEdge() {
    boolean found = false;
    while (!found) {
      intersectMap = new HashMap<PVector, DefaultEdge>();
      generateCandidate();
      // make map with intersect point and which edge it belongs to
      for (DefaultEdge e : g.edgeSet()) {
        PVector p1 = g.getEdgeSource(e);
        PVector p2 = g.getEdgeTarget(e);

        //PVector rayVector, PVector rayPoint, PVector planeNormal, PVector planePoint 
        PVector intersect = intersectPoint(p1.copy().sub(p2), p2, c.n, c.p);

        if (intersect != null) {
          // only accept points on edge
          if (linePoint3D(p1, p2, intersect) && intersect.dist(c.p) < planeRadius) {
            intersectMap.put(intersect, e);
          }
        }
      }
      // need at least 2 intersects to continue
      if (intersectMap.size() < 2) {
        return;
      }
      found = true;
    }
    // split the two edges on their intersecting points:
    // remove the edge and connect intersect with both the source and target
    Object[] values = intersectMap.keySet().toArray();
    int r = gen.nextInt(values.length - 1);
    PVector i1 = (PVector) values[r];
    PVector i2 = (PVector) values[r+1];

    g.addVertex(i1);
    g.addVertex(i2);
    g.addEdge(i1, i2);

    DefaultEdge e1 = intersectMap.get(i1);
    DefaultEdge e2 = intersectMap.get(i2);

    PVector p1 = g.getEdgeSource(e1);
    PVector p2 = g.getEdgeTarget(e1);

    g.removeEdge(e1);
    g.removeEdge(e2);

    g.addEdge(p1, i1);
    g.addEdge(p2, i1);

    p1 = g.getEdgeSource(e2);
    p2 = g.getEdgeTarget(e2);
    g.addEdge(p1, i2);
    g.addEdge(p2, i2);

    for (int j = 0; j < 1; j++) {
      applyForce();
    }
  }



  //TODO: maybe don't allow vertical lines bc sorting on x valu
  void generateCandidate() {
    PVector p = new PVector(random(-scale, scale), 
      random(-scale, scale), random(-scale, scale));

    //PVector p = new PVector(
    //  map(gen.nextFloat(), 0, 1, -scale/2, scale/2), 
    //  map(gen.nextFloat(), 0, 1, -scale/2, scale/2), 
    //  map(gen.nextFloat(), 0, 1, -scale/2, scale/2));   

    p.add(translate);

    PVector n = new PVector(map(gen.nextFloat(), 0, 1, -1, 1), 
      map(gen.nextFloat(), 0, 1, -1, 1), 
      map(gen.nextFloat(), 0, 1, -1, 1));
    n.normalize();

    c.p = p;
    c.n = n;
  }

  // http://eusebeia.dyndns.org/4d/tetrahedron
  void addTetrahydron(int scale, PVector translate, PVector rotate) {
    Graphs.addGraph(g, Shapes3D.tetrahydronGraph(scale, translate, rotate));
    for (PVector p : g.vertexSet()) {
      startingNodes.add(p);
    }
  }

  void addCube(int scale, PVector translate, PVector rotate) {
    Graphs.addGraph(g, Shapes3D.cubeGraph(scale, translate, rotate));
    for (PVector p : g.vertexSet()) {
      startingNodes.add(p);
    }
  }
  
  void addIcosahedron(int scale, PVector translate, PVector rotate) {
    Graphs.addGraph(g, Shapes3D.icosahedronGraph(scale, translate, rotate));
    //for (PVector p : g.vertexSet()) {
    //  startingNodes.add(p);
    //}
  }

  PVector intersectPoint(PVector rayVector, PVector rayPoint, PVector planeNormal, PVector planePoint) {
    if (PVector.dot(planeNormal, rayVector.normalize()) == 0) {
      return null;
    }

    return PVector.add(rayPoint, rayVector.normalize().mult((PVector.dot(planeNormal, planePoint) - PVector.dot(planeNormal, rayPoint)) / PVector.dot(planeNormal, rayVector.normalize())));
  }

  boolean linePoint3D(PVector p1, PVector p2, PVector pp) {
    float x1 = p1.x;
    float y1 = p1.y;
    float z1 = p1.z;
    float x2 = p2.x;
    float y2 = p2.y;
    float z2 = p2.z;
    float x = pp.x;
    float y = pp.y;
    float z = pp.z;
    float AB = sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1)+(z2-z1)*(z2-z1));
    float AP = sqrt((x-x1)*(x-x1)+(y-y1)*(y-y1)+(z-z1)*(z-z1));
    float PB = sqrt((x2-x)*(x2-x)+(y2-y)*(y2-y)+(z2-z)*(z2-z));
    if (AB == AP + PB)
      return true;
    return false;
  }

  // www.jeffreythompson.org/collision-detection/line-line.php
  PVector lineLine(PVector[] e1, PVector[] e2) {

    float x1 = e1[0].x;
    float y1 = e1[0].y;
    float x2 = e1[1].x;
    float y2 = e1[1].y;
    float x3 = e2[0].x;
    float y3 = e2[0].y;
    float x4 = e2[1].x;
    float y4 = e2[1].y;
    // calculate the distance to intersection point
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

    // if uA and uB are between 0-1, lines are colliding
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

      // optionally, draw a circle where the lines meet
      float intersectionX = x1 + (uA * (x2-x1));
      float intersectionY = y1 + (uA * (y2-y1));
      fill(255, 0, 0);
      ellipse(intersectionX, intersectionY, 20, 20);

      return new PVector(intersectionX, intersectionY);
    }
    return null;
  }
}
