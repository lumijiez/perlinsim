class Terrain {
    ArrayList < Block > blocks = new ArrayList < > ();
    ArrayList < Bird > birds = new ArrayList < > ();
    ArrayList < Butterfly > butterflies = new ArrayList < > ();
    float blue = 100;
    float bluedirection = -0.25;

    void addButterfly() {
      if (butterflies.size() < 10)
        butterflies.add(new Butterfly(int(random(1, terrainWidth)) * cubeWidth, int(random(1, terrainLength)) * cubeWidth, 100));
    }

    void addBird() {
      if (birds.size() < 10)
        birds.add(new Bird(int(random(1, terrainWidth)) * cubeWidth, int(random(1, terrainLength)) * cubeWidth, 1200));
    }

    void generateTerrain() {
        for (int i = 0; i < terrainWidth; i++) {
            for (int j = 0; j < terrainLength; j++) {
                Block block = new Block(i, j, noise(noiseStep * i, noiseStep * j), getRandomTreeColor(), int(random(minTreeHeight + 30, maxTreeHeight)));
                blocks.add(block);
                if (random(0, 1) < 0.001) addBird();
                if (random(0, 1) < 0.001) addButterfly();
            }
        }
    }

    void reloadTrees() {
      blocks.forEach(block -> {
        if ((noiseScale * block.h * cubeSize) > 170) {
                if (int(random(0, 101)) < 1) {
                    block.isTree = true;
                    block.treeColor = getRandomTreeColor();
                } else
                    block.isTree = false;
            } else
                block.isTree = false;

            if (!block.isTree && (noiseScale * block.h * cubeSize) > 170) {
                if (int(random(0, 101)) < 1) {
                    block.isFlower = true;
                    block.treeColor = getRandomFlowerColor();
                } else
                    block.isFlower = false;
            } else
                block.isFlower = false;
      });       
    }

    void setup() {
        generateTerrain();
        reloadTrees();
    }

    void drawTerrain(PVector position) {
      blocks.forEach(block -> {
        float blockHeight = noiseScale * block.h * cubeSize;
            
            if (blockHeight < 150) {
                fill(0, 0, int(blue));
                if (blue > 220) bluedirection = -0.15;
                if (blue < 190) bluedirection = 0.15;
                blue += bluedirection;
                blockHeight = 135 + blue / 20;
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
            
            if (dist(posX, 0.0, posY, position.x, 0.0, position.z) > 1500) return;
            
            pushMatrix();

            rotateX(HALF_PI);
            translate(posX, posY, posZ);
            box(cubeWidth, cubeLength, blockHeight);

            if (block.isTree && blockHeight < 350) drawNormalTree(block, posZ);
       else if (block.isTree) drawPineTree(block, posZ);
            
else if (block.isFlower && blockHeight < 350) drawFlower(block, posZ);
            
            popMatrix();
      });
       
        birds.forEach(bird -> bird.draw());
        butterflies.forEach(butterfly -> butterfly.draw());
    }

    void applyGravity() {
        float gravity = 0.001;
        blocks.forEach(block -> {
            block.h -= gravity;
            if (noiseScale * block.h * cubeSize < 170) {
                block.isTree = false;
                block.isFlower = false;
            }
        });
    }
    
    void drawNormalTree(Block block, float posZ) {
                fill(222, 184, 135);
                translate(0, 0, posZ + 50);
                box(cubeWidth, cubeLength, 100);
                translate(0, 0, 50);
                fill(block.treeColor);
                noStroke();
                sphere(block.treeSize);
                stroke(1);
    }
    
    void drawPineTree(Block block, float posZ) {
      fill(222, 184, 135);
                translate(0, 0, posZ + 50);
                box(cubeWidth, cubeLength, 100);
                translate(0, 0, 50);
                fill(0, 100, 0);
                noStroke();
                cylinder(50, 1, 100, 50);
                stroke(1);
    }
    
    void drawFlower(Block block, float posZ) {
      fill(0, 200, 0);
                translate(0, 0, posZ + 10);
                box(5, 5, 20);
                translate(0, 0, 10);
                fill(block.treeColor);
                noStroke();
                sphere(10);
                stroke(1);
    }
}
