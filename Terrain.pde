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
                if (random(0, 1) < 0.001) birds.add(new Bird(i * cubeWidth, j * cubeWidth, 1000));
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
