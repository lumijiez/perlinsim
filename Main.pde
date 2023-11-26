PVector camPosition = new PVector(1000, -700, 700);
PVector lookAt = new PVector(0, 0, -1);
PVector wind = new PVector(5, -8, 0);
Terrain terra = new Terrain();
Balloon balloon = new Balloon(50 * 20, 50 * 20, 20 * 20);

void setup() {
    fullScreen(P3D);
    frameRate(144);
    //size(800, 600, P3D);

    randomSeed(randomSeedValue);
    noiseSeed(noiseSeedValue);
    noiseDetail(noiseOctaves, noiseFalloff);

    terra.setup();
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
        if (key == 'g') terra.applyGravity();

        if (key == 'w') camPosition.add(PVector.mult(lookAt, camSpeed));

        if (key == 's') camPosition.sub(PVector.mult(lookAt, camSpeed));

        if (key == 'a') {
            PVector left = lookAt.cross(new PVector(0, -1, 0));
            camPosition.add(PVector.mult(left, camSpeed));
        }

        if (key == 'd') {
            PVector right = lookAt.cross(new PVector(0, -1, 0));
            camPosition.sub(PVector.mult(right, camSpeed));
        }
        
       if (key == 'r') terra.blocks.get(0).x += 1;
       if (key == 'f') terra.blocks.get(0).y += 1;
    }

    camera(camPosition.x, camPosition.y, camPosition.z, camPosition.x + lookAt.x, camPosition.y + lookAt.y, camPosition.z + lookAt.z, 0, 1, 0);
    perspective(PI / 3.0, float(width) / float(height), 1, farPlaneDistance);

    terra.drawTerrain(camPosition);

    PVector windForce = wind.copy().mult(0.1);
    balloon.applyForce(windForce);
    balloon.draw();
}
