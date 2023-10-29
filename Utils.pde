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
  float yellowBrightness = 150;
  float rand1 = yellowBrightness + randomGaussian() * 25;
  float rand2 = yellowBrightness + randomGaussian() * 25;
  float rand3 = yellowBrightness + randomGaussian() * 25;
  
  rand1 = constrain(rand1, 0, 255); 
  rand2 = constrain(rand2, 0, 255);
  rand3 = constrain(rand3, 0, 255);
  
  return color(rand1, rand2, rand3);
}
