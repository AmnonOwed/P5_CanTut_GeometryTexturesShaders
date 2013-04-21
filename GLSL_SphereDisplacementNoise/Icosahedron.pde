
// ported to Processing 1.5.1 and GLGraphics 1.0.0 by Amnon Owed (20/01/2013)
// from code by Gabor Papp (13/03/2010): http://git.savannah.gnu.org/cgit/fluxus.git/tree/libfluxus/src/GraphicsUtils.cpp
// based on explanation by Paul Bourke (01/12/1993): http://paulbourke.net/geometry/platonic
// using vertex/face list by Craig Reynolds: http://paulbourke.net/geometry/platonic/icosahedron.vf

class Icosahedron {
  ArrayList <PVector> positions = new ArrayList <PVector> ();
  ArrayList <PVector> normals = new ArrayList <PVector> ();
  ArrayList <PVector> texCoords = new ArrayList <PVector> ();

  Icosahedron(int level) {
    float sqrt5 = sqrt(5);
    float phi = (1 + sqrt5) * 0.5;
    float ratio = sqrt(10 + (2 * sqrt5)) / (4 * phi);
    float a = (1 / ratio) * 0.5;
    float b = (1 / ratio) / (2 * phi);

    PVector[] vertices = {
      new PVector( 0,  b, -a), 
      new PVector( b,  a,  0), 
      new PVector(-b,  a,  0), 
      new PVector( 0,  b,  a), 
      new PVector( 0, -b,  a), 
      new PVector(-a,  0,  b), 
      new PVector( 0, -b, -a), 
      new PVector( a,  0, -b), 
      new PVector( a,  0,  b), 
      new PVector(-a,  0, -b), 
      new PVector( b, -a,  0), 
      new PVector(-b, -a,  0)
    };

    int[] indices = { 
      0,1,2,    3,2,1,
      3,4,5,    3,8,4,
      0,6,7,    0,9,6,
      4,10,11,  6,11,10,
      2,5,9,    11,9,5,
      1,7,8,    10,8,7,
      3,5,2,    3,1,8,
      0,2,9,    0,7,1,
      6,9,11,   6,10,7,
      4,11,5,   4,8,10
    };

    for (int i=0; i<indices.length; i += 3) {
      makeIcosphereFace(vertices[indices[i]],  vertices[indices[i+1]],  vertices[indices[i+2]],  level);
    }
  }

  void makeIcosphereFace(PVector a, PVector b, PVector c, int level) {

    if (level <= 1) {
      
      // cartesian to spherical coordinates
      PVector ta = new PVector(atan2(a.z, a.x) / TWO_PI + 0.5, acos(a.y) / PI);
      PVector tb = new PVector(atan2(b.z, b.x) / TWO_PI + 0.5, acos(b.y) / PI);
      PVector tc = new PVector(atan2(c.z, c.x) / TWO_PI + 0.5, acos(c.y) / PI);

      // texture wrapping coordinate limits
      float mint = 0.25;
      float maxt = 1 - mint;

      // fix north and south pole textures
      if ((a.x == 0) && ((a.y == 1) || (a.y == -1))) {
        ta.x = (tb.x + tc.x) / 2;
        if (((tc.x < mint) && (tb.x > maxt)) || ((tb.x < mint) && (tc.x > maxt))) { ta.x += 0.5; }
      } else if ((b.x == 0) && ((b.y == 1) || (b.y == -1))) {
        tb.x = (ta.x + tc.x) / 2;
        if (((tc.x < mint) && (ta.x > maxt)) || ((ta.x < mint) && (tc.x > maxt))) { tb.x += 0.5; }
      } else if ((c.x == 0) && ((c.y == 1) || (c.y == -1))) {
        tc.x = (ta.x + tb.x) / 2;
        if (((ta.x < mint) && (tb.x > maxt)) || ((tb.x < mint) && (ta.x > maxt))) { tc.x += 0.5; }
      }

      // fix texture wrapping
      if ((ta.x < mint) && (tc.x > maxt)) {
        if (tb.x < mint) { tc.x -= 1; } else { ta.x += 1; }
      } else if ((ta.x < mint) && (tb.x > maxt)) {
        if (tc.x < mint) { tb.x -= 1; } else { ta.x += 1; }
      } else if ((tc.x < mint) && (tb.x > maxt)) {
        if (ta.x < mint) { tb.x -= 1; } else { tc.x += 1; }
      } else if ((ta.x > maxt) && (tc.x < mint)) {
        if (tb.x < mint) { ta.x -= 1; } else { tc.x += 1; }
      } else if ((ta.x > maxt) && (tb.x < mint)) {
        if (tc.x < mint) { ta.x -= 1; } else { tb.x += 1; }
      } else if ((tc.x > maxt) && (tb.x < mint)) {
        if (ta.x < mint) { tc.x -= 1; } else { tb.x += 1; }
      }

      addVertex(a, a, ta);
      addVertex(c, c, tc);
      addVertex(b, b, tb);

    } else { // level > 1

      PVector ab = midpointOnSphere(a, b);
      PVector bc = midpointOnSphere(b, c);
      PVector ca = midpointOnSphere(c, a);

      level--;
      makeIcosphereFace(a, ab, ca, level);
      makeIcosphereFace(ab, b, bc, level);
      makeIcosphereFace(ca, bc, c, level);
      makeIcosphereFace(ab, bc, ca, level);
    }
  }

  void addVertex(PVector p, PVector n, PVector t) {
    positions.add(p);
    normals.add(n);
    t.mult(-1);
    texCoords.add(t);
  }

  PVector midpointOnSphere(PVector a, PVector b) {
    PVector midpoint = PVector.add(a, b);
    midpoint.mult(0.5);
    midpoint.normalize();
    return midpoint;
  }
}

GLModel createIcosahedron(int level) {
  Icosahedron ico = new Icosahedron(level);
  
  GLModel mesh = new GLModel(this, ico.positions.size(), TRIANGLES, GLModel.STATIC);

  // positions
  mesh.updateVertices(ico.positions);
  
  // normals
  mesh.initNormals();
  mesh.updateNormals(ico.normals);

  // texCoords + textures
  mesh.initTextures(1);
  mesh.updateTexCoords(0, ico.texCoords);
  GLTextureParameters textureParameters = new GLTextureParameters();
  textureParameters.wrappingU = REPEAT;
  textureParameters.wrappingV = REPEAT;
  texColorMap = new GLTexture(this, 1000, 1000, textureParameters);
  mesh.setTexture(0, texColorMap);
  setColorMap(currentColorMap);

  return mesh;
}

