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

long randomSeedValue = 42; 
long noiseSeedValue = 24;  
int noiseOctaves = 4;
float noiseFalloff = 0.5;

Terrain terra = new Terrain();

void setup() {
    fullScreen(P3D);
    frameRate(144);

    randomSeed(randomSeedValue);
    noiseSeed(noiseSeedValue);
    noiseDetail(noiseOctaves, noiseFalloff);

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
