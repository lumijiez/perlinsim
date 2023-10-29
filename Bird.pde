class Bird {
  float x;
  float y;
  float z; 
  float radius;
  float angle;
  float angleSpeed = 0.01 + random(0.0005 - 0.00001);
  int directionX = (random(0, 1) < 0.5) ? 1 : -1;
  int directionY = (random(0, 1) < 0.5) ? 1 : -1;
  float wingAngle1 = PI;
  float wingAngle2 = PI;
  int wingDirection1 = 1;
  int wingDirection2 = 1;
  float wingFlapSpeed = 0.05;
  float wingFlapRange = QUARTER_PI;
  float perlinOffset;

  Bird(float x, float y, float z) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.radius = 500;
    this.angle = 0;
    this.perlinOffset = random(1000); 
  }

  void drawBird() {
    pushMatrix();

    float angleX = HALF_PI;
    float angleY = 0;

    rotateX(angleX);
    rotateY(angleY);

    float birdZ = map(noise(perlinOffset, millis() * 0.0002), 0, 1, 800, 1000);
    
    translate(x, y, birdZ);
    float birdX = cos(angle) * radius * directionX;
    float birdY = sin(angle) * radius * directionY;

    translate(birdX, birdY, 0);

    fill(100, 100, 100);
    box(10, 10, 10);
    
    translate(-6, 3, 5);
    box(6, 6, 6);
    
    translate(6, -3, -5);
    translate(0, -5, 5);

    float wingFlap1 = sin(wingAngle1) * wingFlapRange;
    rotateX(wingFlap1);

    if (wingAngle1 >= PI + wingFlapRange || wingAngle1 <= PI - wingFlapRange) {
      wingDirection1 *= -1;
    }

    wingAngle1 += wingDirection1 * wingFlapSpeed;

    fill(128, 128, 128);
    drawWing(10, 30, 5);

    rotateX(-wingFlap1);
    translate(5, 5);
    rotateZ(HALF_PI);
    
    float wingFlap2 = sin(wingAngle2) * wingFlapRange;
    rotateX(wingFlap2);
    
    if (wingAngle2 >= PI + wingFlapRange || wingAngle2 <= PI - wingFlapRange) {
      wingDirection2 *= -1;
    }

    wingAngle2 += wingDirection2 * wingFlapSpeed;

    fill(128, 128, 128);
    drawWing(10, 30, 5);

    angle += angleSpeed;

    popMatrix();
  }

  void drawWing(float width, float length, float thickness) {
    beginShape();
    vertex(-width / 2, 0);
    vertex(width / 2, 0);
    vertex(width / 4, -length);
    vertex(-width / 4, -length);
    endShape(CLOSE);
  }
}
