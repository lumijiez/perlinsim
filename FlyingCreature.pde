abstract class FlyingCreature {
    float x;
    float y;
    float z;
    float hp;
    float goBackX, goBackY, goBackZ;
    float wingAngle = PI;
    int wingDirection = 1;
    float wingFlapSpeed = 0.05;
    float wingFlapRange = QUARTER_PI;
    float perlinOffsetX;
    float perlinOffsetY;
    float perlinOffsetZ;
    float actualOffset = 1;
    boolean isCatching = false;
    boolean needToGoBack = false;
    Butterfly butterfly = null;
    color fillcolor = color(0, 0, 0);

    FlyingCreature(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.perlinOffsetX = random(1000);
        this.perlinOffsetY = random(1000);
        this.perlinOffsetZ = random(1000);
    }

    void catchButterfly() {
        ArrayList < Butterfly > availableButterflies = new ArrayList < > ();
        for (Butterfly butterfly: terra.butterflies) {
            if (!butterfly.isBeingCaught) {
                availableButterflies.add(butterfly);
            }
        }

        if (!availableButterflies.isEmpty()) {
            int randomIndex = (int) random(availableButterflies.size());

            Butterfly randomButterfly = availableButterflies.get(randomIndex);

            butterfly = randomButterfly;
            isCatching = true;
            fillcolor = color(255, 255, 255);

            randomButterfly.isBeingCaught = true;
            goBackX = x;
            goBackY = y;
            goBackZ = z;
        }

    }

    void uncatchButterfly() {
        terra.butterflies.remove(butterfly);
        terra.addButterfly();
        butterfly = null;
        isCatching = false;
        needToGoBack = true;
        fillcolor = color(0, 0, 0);
        hp = 100;
    }

    void tryGoBack() {
        this.hp -= 0.1;
        pushMatrix();
        rotateX(HALF_PI);

        if (dist(x, y, z, goBackX, goBackY, goBackZ) > 10) {
            int speed = 5;
            float dirX = goBackX - x;
            float dirY = goBackY - y;
            float dirZ = goBackZ - z;

            // Normalize the direction vector
            float magnitude = sqrt(dirX * dirX + dirY * dirY + dirZ * dirZ);
            dirX /= magnitude;
            dirY /= magnitude;
            dirZ /= magnitude;

            x += dirX * speed;
            y += dirY * speed;
            z += dirZ * speed;
        } else {
            popMatrix();
            needToGoBack = false;
            x = goBackX;
            y = goBackY;
            z = goBackZ;
            return;
        }

        translate(x, y, z);

        translate(0, 0, 20);
        float colorValue = map(hp, 0, 100, 0, 1);
        colorValue = constrain(colorValue, 0, 1);

        color boxColor = lerpColor(color(255, 0, 0), color(0, 255, 0), colorValue);
        fill(boxColor);
        box(2, hp / 10, 2);

        translate(0, 0, -20);

        fill(fillcolor);
        box(10, 10, 10);

        translate(-6, 3, 5);
        box(6, 6, 6);

        translate(6, -3, -5);
        translate(0, -5, 5);

        float wingFlap = sin(wingAngle) * wingFlapRange;
        rotateX(wingFlap);

        wingDirection = (wingAngle >= PI + wingFlapRange || wingAngle <= PI - wingFlapRange) ? -wingDirection : wingDirection;

        wingAngle += wingDirection * wingFlapSpeed;

        fill(fillcolor);
        drawWing(10, 30);

        rotateX(-wingFlap);
        translate(5, 5);
        rotateZ(HALF_PI);

        rotateX(wingFlap);

        drawWing(10, 30);

        popMatrix();
    }

    void draw() {
        this.hp -= 0.1;

        if (!isCatching && random(1) < 0.01) {
            catchButterfly();
        }

        if (needToGoBack) {
            tryGoBack();
            return;
        }

        if (!isCatching) {
            pushMatrix();
            rotateX(HALF_PI);

            translate(x, y, z);

            translate(0, 0, 20);
            float colorValue = map(hp, 0, 100, 0, 1);
            colorValue = constrain(colorValue, 0, 1);

            color boxColor = lerpColor(color(255, 0, 0), color(0, 255, 0), colorValue);
            fill(boxColor);
            box(2, hp / 10, 2);

            translate(0, 0, -20);

            actualOffset += 10;

            z = map(noise(perlinOffsetX, actualOffset * 0.0002), 0, 1, 600, 1200);
            x = map(noise(perlinOffsetY, actualOffset * 0.0001), 0, 1, 0, terrainLength * cubeWidth);
            y = map(noise(perlinOffsetZ, actualOffset * 0.0001), 0, 1, 0, terrainWidth * cubeWidth);

            fill(fillcolor);
            box(10, 10, 10);

            translate(-6, 3, 5);
            box(6, 6, 6);

            translate(6, -3, -5);
            translate(0, -5, 5);

            float wingFlap = sin(wingAngle) * wingFlapRange;
            rotateX(wingFlap);

            wingDirection = (wingAngle >= PI + wingFlapRange || wingAngle <= PI - wingFlapRange) ? -wingDirection : wingDirection;

            wingAngle += wingDirection * wingFlapSpeed;

            fill(fillcolor);
            drawWing(10, 30);

            rotateX(-wingFlap);
            translate(5, 5);
            rotateZ(HALF_PI);

            rotateX(wingFlap);

            drawWing(10, 30);

            popMatrix();

        } else {
            this.hp -= 0.1;
            pushMatrix();
            rotateX(HALF_PI);

            float dirX = butterfly.x - x;
            float dirY = butterfly.y - y;
            float dirZ = butterfly.z - z;

            float magnitude = sqrt(dirX * dirX + dirY * dirY + dirZ * dirZ);
            dirX /= magnitude;
            dirY /= magnitude;
            dirZ /= magnitude;

            float speed = 4.0;

            x += dirX * speed;
            y += dirY * speed;
            z += dirZ * speed;

            translate(x, y, z);

            translate(0, 0, 20);
            float colorValue = map(hp, 0, 100, 0, 1);
            colorValue = constrain(colorValue, 0, 1);

            color boxColor = lerpColor(color(255, 0, 0), color(0, 255, 0), colorValue);
            fill(boxColor);
            box(2, hp / 10, 2);

            translate(0, 0, -20);

            fill(fillcolor);
            box(10, 10, 10);

            translate(-6, 3, 5);
            box(6, 6, 6);

            translate(6, -3, -5);
            translate(0, -5, 5);

            float wingFlap = sin(wingAngle) * wingFlapRange;
            rotateX(wingFlap);

            wingDirection = (wingAngle >= PI + wingFlapRange || wingAngle <= PI - wingFlapRange) ? -wingDirection : wingDirection;

            wingAngle += wingDirection * wingFlapSpeed;

            fill(fillcolor);
            drawWing(10, 30);

            rotateX(-wingFlap);
            translate(5, 5);
            
            rotateZ(HALF_PI);
            rotateX(wingFlap);

            drawWing(10, 30);

            if (dist(x, y, z, butterfly.x, butterfly.y, butterfly.z) < 20) uncatchButterfly();

            popMatrix();
        }

        if (hp < 0) hp = 100;
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
