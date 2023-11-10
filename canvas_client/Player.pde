class Player{

    JSONObject json;
    int id;
    int x,y;
    int brushR, brushG, brushB, brushSize;

    // Default Constructor no Parameters (used on Server cause Id gets added later)
    Player(){
        id = 0;
        x = 0;
        y = 0;
        brushR = int(random(255));
        brushG = int(random(255));
        brushB = int(random(255));
        brushSize = 32; 
    }


    // Constructor that takes an integer id (used in myPlayer)
    Player(int id){
        this.id = id;
        x = 0;
        y = 0;
        brushR = int(random(255));
        brushG = int(random(255));
        brushB = int(random(255));
        brushSize = 32; 
    }

    // Constructor that takes a json_string and parses it into the Playerobject
    Player(JSONObject json){

        id = json.getInt("id");
        x = json.getInt("x");
        y = json.getInt("y");
        brushR = json.getInt("r");
        brushG = json.getInt("g");
        brushB = json.getInt("b");
        brushSize = json.getInt("size");
    }

    void display(){
        ellipseMode(CENTER);
        fill(brushR, brushG, brushB);
        noStroke();

        pushMatrix();
        translate(x,y);
        ellipse(0,0, brushSize, brushSize);
        popMatrix();
    }

    JSONObject getShortJson(){
        json = new JSONObject();

        json.setInt("id", id);
        json.setInt("x", x);
        json.setInt("y", y);

        return json;
    }

    JSONObject getJSON(){
        json = new JSONObject();

        json.setInt("id", id);
        json.setInt("x", x);
        json.setInt("y", y);
        json.setInt("r", brushR);
        json.setInt("g", brushG);
        json.setInt("b", brushB);
        json.setInt("size", brushSize);

        return json;
    }

    public void setXY(int x, int y) {
        this.x = x;
        this.y = y;
    }

    public int getId(){
        return id;
    }

    public int getBrushR() {
        return this.brushR;
    }

    public int getBrushG(){
        return this.brushG;
    }

    public int getBrushB(){
        return this.brushB;
    }

    public void setBrushR(int brushR) {
        this.brushR = brushR;
    }

    public void setBrushG(int brushG) {
        this.brushG = brushG;
    }

    public void setBrushB(int brushB) {
        this.brushB = brushB;
    }

    public void setBrushSize(int brushSize) {
        this.brushSize = brushSize;
    }

    public int getBrushSize(){
        return brushSize;
    }

    public void setId(int id){
        this.id = id;
    }

}