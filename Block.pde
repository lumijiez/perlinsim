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
