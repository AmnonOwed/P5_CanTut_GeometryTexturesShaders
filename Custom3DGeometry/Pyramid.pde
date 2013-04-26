
class Pyramid {
  PVector[] v = new PVector[5];
  color[] c = new color[5];
  float pHeight, pRadius;
  float speed, transparency;
  float x, y, z;
  
  Pyramid(float pHeight, float pRadius) {
    this.pHeight = pHeight/2;
    this.pRadius = pRadius;
    speed = random(MAXSPEED/8, MAXSPEED);
    createPyramid();
    z = random(-5000, 750);
    reset();
  }
  
  void createPyramid() {
    v[0] = new PVector(0, -pHeight, 0);
    v[1] = new PVector(pRadius*cos(HALF_PI), pHeight, pRadius*sin(HALF_PI));
    v[2] = new PVector(pRadius*cos(PI), pHeight, pRadius*sin(PI));
    v[3] = new PVector(pRadius*cos(1.5*PI), pHeight, pRadius*sin(1.5*PI));
    v[4] = new PVector(pRadius*cos(TWO_PI), pHeight, pRadius*sin(TWO_PI));
  }
  
  void update() {
    z += speed;
    if (z > 750) { z = -5000; reset(); }
    transparency = z<-2500?map(z, -5000, -2500, 0, 255):255;
  }
  
  void display() {
    pushMatrix();
    
    translate(x, y, z);
    rotateY(x + frameCount*0.01);
    rotateX(y + frameCount*0.02);
    
    beginShape(TRIANGLE_FAN);
    for (int i=0; i<5; i++) {
      fill(c[i], transparency);
      vertex(v[i].x, v[i].y, v[i].z);
    }
    fill(c[1], transparency);
    vertex(v[1].x, v[1].y, v[1].z);
    endShape();
    
    fill(c[1], transparency);
    beginShape(QUAD);
    for (int i=1; i<5; i++) {
      vertex(v[i].x, v[i].y, v[i].z);
    }
    endShape();
    
    popMatrix();
  }
  
  void reset() {
    x = random(-2*width, 3*width);
    y = random(-height, 2*height);
    c[0] = color(random(150, 255), random(150, 255), random(150, 255));
    for (int i=1; i<5; i++) {
      c[i] = color(random(255), random(255), random(255));
    }
  }
}

