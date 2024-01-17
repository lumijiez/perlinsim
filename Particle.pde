class Particle {
    float x, y, z;
    float speed;
    color col;
    float permOffset;
    float offset = 0;
    Block block;

    Particle(float x, float y, float z, Block block, float speed, float treeSize) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.block = block;
        this.speed = speed;
        this.permOffset = -150 - treeSize;
    }

    void update() {
        offset -= speed;
        if (offset < -100) offset = 0;
    }

    void display(float posZ) {
        pushMatrix();
        translate(x, y, posZ + permOffset + offset);
        fill(block.treeColor);
        float scaleDown = map(offset, 0, -150, 1, 10);
        box(10/scaleDown, 8/scaleDown, 8/scaleDown);
        scale(offset);
        popMatrix();
        update();
    }
}
