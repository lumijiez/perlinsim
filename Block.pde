class Block {
    int x;
    int y;
    float h;
    boolean isTree;
    boolean isFlower;
    int treeSize;
    color treeColor;
    ArrayList<Particle> particles = new ArrayList<>();
    Block(int x, int y, float h, color treeColor, int treeSize) {
        this.x = x;
        this.y = y;
        this.h = h;
        this.treeColor = treeColor;
        this.treeSize = treeSize;
        for (int i = 0; i < 4; i++) {
              float angleInRadians = map(i, 0, 10, 0, TWO_PI); 
              particles.add(new Particle(cubeWidth * cos(angleInRadians), cubeWidth * sin(angleInRadians), 0, this, random(0.5, 1), h/2));
            }
    }
    
    void drawParticles(float posZ) {
      particles.forEach(particle -> particle.display(posZ));
    }
}
