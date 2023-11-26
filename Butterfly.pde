class Butterfly {
    float x;
    float y;
    float z;
    float wingAngle = PI;
    int wingDirection = 1;
    float wingFlapSpeed = 0.05;
    float wingFlapRange = QUARTER_PI;
    float perlinOffsetX;
    float perlinOffsetY;
    float perlinOffsetZ;
    boolean isBeingCaught = false;

    Butterfly(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.perlinOffsetX = random(1000);
        this.perlinOffsetY = random(1000);
        this.perlinOffsetZ = random(1000);
    }

    void draw() {
        pushMatrix();
        rotateX(HALF_PI);

        z = map(noise(perlinOffsetX, millis() * 0.0002), 0, 1, 400, 600);
        x = map(noise(perlinOffsetY, millis() * 0.0001), 0, 1, 0, terrainLength * cubeWidth);
        y = map(noise(perlinOffsetZ, millis() * 0.0001), 0, 1, 0, terrainWidth * cubeWidth);

        fill(0, 191, 255);
        translate(x, y, z);
        box(3, 3, 3);
        translate(-1, 1, 2);
        box(2, 2, 2);
        translate(1, -2, -1);

        float wingFlap = sin(wingAngle) * wingFlapRange;
        rotateX(wingFlap);

        wingDirection = (wingAngle >= PI + wingFlapRange || wingAngle <= PI - wingFlapRange) ? -wingDirection : wingDirection;

        wingAngle += wingDirection * wingFlapSpeed;

        fill(0, 191, 255);
        drawWing(3, 5);

        rotateX(-wingFlap);
        translate(1, 1);
        rotateZ(HALF_PI);

        rotateX(wingFlap);

        fill(0, 191, 255);
        drawWing(3, 5);
        popMatrix();
    }

    void drawWing(float width, float length) {
        beginShape();
        vertex(-width / 2, 0);
        vertex(width / 2, 0);
        vertex(width / 4, -length);
        vertex(-width / 4, -length);
        endShape(CLOSE);
    }
}
