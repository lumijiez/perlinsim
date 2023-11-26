class Balloon {
    float x;
    float y;
    float z;
    float radius;
    float angle;
    PVector velocity;
    PVector acceleration;
    float lastWindChangeTime;

    Balloon(float x, float y, float z) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.radius = 50;
        this.velocity = new PVector(0, 0, 0);
        this.acceleration = new PVector(0, 0, 0);
        this.angle = 0;
    }

    void applyForce(PVector force) {
        acceleration.add(force);
    }

    void applyBuoyancy() {
        PVector buoyantForce = new PVector(0, 0, buoyancy);
        applyForce(buoyantForce);
    }

    void applyDamping() {
        PVector dampingForce = velocity.copy().mult(-damping);
        applyForce(dampingForce);
    }

    void draw() {
        pushMatrix();
      
        if (millis() - lastWindChangeTime > windChangeInterval) {
            wind = PVector.random3D();
            wind.mult(20);
            lastWindChangeTime = millis();
        }

        rotateX(HALF_PI);

        z += 2;

        translate(x, y, z);

        fill(255, 0, 0);
        noStroke();
        sphere(radius);
        stroke(1);

        drawLeg(-radius / 2, -radius / 2);
        drawLeg(radius / 2, -radius / 2);
        drawLeg(-radius / 2, radius / 2);
        drawLeg(radius / 2, radius / 2);

        translate(0, 0, -75);
        box(70, 70, 25);

        applyBuoyancy();
        applyDamping();

        velocity.add(acceleration);
        x += velocity.x;
        y += velocity.y;
        z += velocity.z;

        acceleration.mult(0);
        angle += 0.01;

        popMatrix();
    }

    void drawLeg(float x, float y) {
        pushMatrix();
        int legHeight = 80;
        translate(x, y, -legHeight / 2);
        fill(yellow);
        box(5, 5, legHeight);
        popMatrix();
    }
}
