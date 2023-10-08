color yellow = color(255, 255, 0);
color green = color(0, 255, 0);
color blue = color(0, 0, 255);
color red = color(255, 0, 0);
color darkgreen = color(0, 100, 0);
color autumn1 = color(183, 65, 14);
color autumn2 = color(204, 85, 0);
color autumn3 = color(255, 215, 0);
color autumn4 = color(255, 204, 0);
color autumn5 = color(139, 69, 19);
color autumn6 = color(101, 67, 33);
color autumn7 = color(107, 142, 35);

PVector camPosition;
PVector lookAt;
float camSpeed = 20;
float sensitivity = 0.01;
float pitch = 0;
float yaw = 0;
int farPlaneDistance = 3000;

float cubeSize = 100;
float cubeWidth = 20;
float noiseScale = 5;

Terrain terra = new Terrain();

void setup() {
    fullScreen(P3D);
    frameRate(144);
    camPosition = new PVector(0, 0, 0);
    lookAt = new PVector(0, 0, -1);
    terra.generateTerrain();
    terra.reloadTrees();
}

void keyPressed() {
    if (keyCode == UP) {
        noiseScale += 0.25;
        terra.reloadTrees();
    } else if (keyCode == DOWN) {
        noiseScale -= 0.25;
        terra.reloadTrees();
    }
}

void draw() {
    background(173, 216, 230);
    lights();

    yaw += -1 * sensitivity * (mouseX - pmouseX);
    pitch += sensitivity * (mouseY - pmouseY);

    pitch = constrain(pitch, -HALF_PI + 0.01, HALF_PI - 0.01);

    float cosPitch = cos(pitch);
    float sinPitch = sin(pitch);
    float cosYaw = cos(yaw);
    float sinYaw = sin(yaw);

    lookAt.x = sinYaw * cosPitch;
    lookAt.y = sinPitch;
    lookAt.z = cosYaw * cosPitch;

    if (keyPressed) {
        if (key == 'w') {
            camPosition.add(PVector.mult(lookAt, camSpeed));
        }
        if (key == 's') {
            camPosition.sub(PVector.mult(lookAt, camSpeed));
        }
        if (key == 'a') {
            PVector left = lookAt.cross(new PVector(0, -1, 0));
            camPosition.add(PVector.mult(left, camSpeed));
        }
        if (key == 'd') {
            PVector right = lookAt.cross(new PVector(0, -1, 0));
            camPosition.sub(PVector.mult(right, camSpeed));
        }
    }

    camera(camPosition.x, camPosition.y, camPosition.z, camPosition.x + lookAt.x, camPosition.y + lookAt.y, camPosition.z + lookAt.z, 0, 1, 0);
    perspective(PI / 3.0, float(width) / float(height), 1, farPlaneDistance);

    terra.drawTerrain();
}

class Terrain {
    ArrayList < Block > blocks = new ArrayList<>();
    ArrayList < Bird > birds = new ArrayList<>();
    int terrainLength = 100;
    int terrainWidth = 100;
    int minTreeHeight = 20;
    int maxTreeHeight = 70;
    float noiseStep = 0.02;
    int cubeWidth = 20;
    int cubeLength = 20;

    void generateTerrain() {
        for (int i = 0; i < terrainWidth; i++) {
            for (int j = 0; j < terrainLength; j++) {
                Block block = new Block(i, j, noise(noiseStep * i, noiseStep * j), getRandomTreeColor(), int(random(minTreeHeight, maxTreeHeight)));
                blocks.add(block);
                if (random(0, 1) < 0.001) birds.add(new Bird(i * cubeWidth, j * cubeWidth));
            }
        }
    }

    void reloadTrees() {
        for (int i = 0; i < blocks.size(); i++) {
            Block block = blocks.get(i);
            if ((noiseScale * block.h * cubeSize) > 170) {
                if (int(random(0, 101)) < 1) {
                  block.isTree = true;
                  block.treeColor = getRandomTreeColor();
                }
                else block.isTree = false;
            } else block.isTree = false;
            
           if (!block.isTree && (noiseScale * block.h * cubeSize) > 170) {
             if (int(random(0, 101)) < 1) {
               block.isFlower = true;
               block.treeColor = getRandomFlowerColor();
             }
             else block.isFlower = false;
           }
           else block.isFlower = false;
        }
    }

    void drawTerrain() {
        for (int i = 0; i < blocks.size(); i++) {
            Block block = blocks.get(i);
            float blockHeight = noiseScale * block.h * cubeSize;

            if (blockHeight < 150) {
                fill(0, 0, 255);
                blockHeight = 150;
            } else if (blockHeight > 150 && blockHeight < 170) {
                fill(yellow);
            } else if (blockHeight > 350) {
                blockHeight *= 1.5;
                fill(255, 255, 255);
            } else {
                fill(green);
            }

            float posX = block.x * cubeWidth;
            float posY = block.y * cubeLength;
            float posZ = blockHeight / 2.0;

            float angleX = HALF_PI;
            float angleY = 0;

            pushMatrix();

            rotateX(angleX);
            rotateY(angleY);
            translate(posX, posY, posZ);
            box(cubeWidth, cubeLength, blockHeight);

            if (block.isTree && blockHeight < 350) {
                fill(222, 184, 135);
                translate(0, 0, posZ + 50);
                box(cubeWidth, cubeLength, 100);
                translate(0, 0, 50);
                fill(block.treeColor);
                noStroke();
                sphere(block.treeSize);
                stroke(1);
            } else if (block.isTree) {
                fill(222, 184, 135);
                translate(0, 0, posZ + 50);
                box(cubeWidth, cubeLength, 100);
                translate(0, 0, 50);
                fill(0, 100, 0);
                noStroke();
                cylinder(50, 1, 100, 50);
                stroke(1);
            }
            
            if (block.isFlower && blockHeight < 350) {
                fill(0, 200, 0);
                translate(0, 0, posZ + 10);
                box(5, 5 , 20);
                translate(0, 0, 10);
                fill(block.treeColor);
                noStroke();
                sphere(10);
                stroke(1);
            }
            popMatrix();
        }
        for (int i = 0; i < birds.size(); i++) {
          Bird bird = birds.get(i);
          bird.drawBird();
        }
        
    }
}

class Block {
    int x;
    int y;
    float h;
    boolean isTree;
    boolean isFlower;
    int treeSize;
    color treeColor;
    Block(int x, int y, float h, color treeColor, int treeSize) {
        this.x = x;
        this.y = y;
        this.h = h;
        this.treeColor = treeColor;
        this.treeSize = treeSize;
    }
}

class Bird {
  float x;
  float y;
  float radius;
  float angle;
  float angleSpeed = 0.01 + random(0.05 - 0.01);
  int directionX = (random(0, 1) < 0.5) ? 1 : -1;
  int directionY = (random(0, 1) < 0.5) ? 1 : -1;
  
  Bird(float x, float y) {
    this.x = x;
    this.y = y;
    this.radius = 500;
    this.angle = 0;
  }
  
  void drawBird() {
    pushMatrix();
    
    float angleX = HALF_PI;
    float angleY = 0;
      
    rotateX(angleX);
    rotateY(angleY);
      
    translate(x, y, 1000);
    float birdX = cos(angle) * radius * directionX;
    float birdY = sin(angle) * radius * directionY;
    float birdZ = sin(angle) * radius;
    
    translate(birdX, birdY, birdZ);
    
    fill(0, 0, 0);
    box(10, 10, 10);
    
    angle += angleSpeed;
    
    popMatrix();
  }
}


color getRandomTreeColor() {
    int rand = int(random(0, 101));
    if (rand < 10) return color(255, 69, 0);
    else if (rand < 20) return autumn1;
    else if (rand < 30) return autumn2;
    else if (rand < 40) return autumn3;
    else if (rand < 50) return autumn4;
    else if (rand < 60) return autumn5;
    else if (rand < 70) return autumn6;
    else if (rand < 80) return autumn7;
    return darkgreen;
}

color getRandomFlowerColor() {
  int rand = int(random(0, 101));
  if (rand < 50) return red;
  return yellow;
}


void cylinder(float bottom, float top, float h, int sides) {
    pushMatrix();
    float angleX = HALF_PI;
    float angleY = 0;
    rotateX(angleX);
    rotateY(angleY);
    translate(0, h / 2, 0);

    float angle;
    float[] x = new float[sides + 1];
    float[] z = new float[sides + 1];

    float[] x2 = new float[sides + 1];
    float[] z2 = new float[sides + 1];

    for (int i = 0; i < x.length; i++) {
        angle = TWO_PI / (sides) * i;
        x[i] = sin(angle) * bottom;
        z[i] = cos(angle) * bottom;
    }

    for (int i = 0; i < x.length; i++) {
        angle = TWO_PI / (sides) * i;
        x2[i] = sin(angle) * top;
        z2[i] = cos(angle) * top;
    }

    beginShape(TRIANGLE_FAN);

    vertex(0, -h / 2, 0);

    for (int i = 0; i < x.length; i++) {
        vertex(x[i], -h / 2, z[i]);
    }

    endShape();

    beginShape(QUAD_STRIP);

    for (int i = 0; i < x.length; i++) {
        vertex(x[i], -h / 2, z[i]);
        vertex(x2[i], h / 2, z2[i]);
    }

    endShape();

    beginShape(TRIANGLE_FAN);

    vertex(0, h / 2, 0);

    for (int i = 0; i < x.length; i++) {
        vertex(x2[i], h / 2, z2[i]);
    }

    endShape();

    popMatrix();
}
