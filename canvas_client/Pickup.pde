import java.util.Random; // Used in SizePickup for either - or + BrushSize

// Parent Class from which ColorPickup and SizePickup inherit from
class Pickup{
  int x,y;
  int radius;
  int frameCreated;
  
  // Default constructor (no arguments)
  Pickup(){
    x = int(random(width/2));
    y = int(random(height));
    radius = 40;
    frameCreated = frameCount;
  }
  
  // Display Pickup on Screen
  void display(){
    fill(0);
    ellipse(x,y,radius,radius);
  }
  
  // Check if the Brush touches the Pickup
  boolean collision(int brushSize){
    boolean b;
    if( (mouseX <= x+brushSize && mouseX >= x-brushSize) && (mouseY <= y+brushSize && mouseY >= y-brushSize) ){
      b = true;
    }
    else{
      b = false;
    }
    return b;
  }
  
  // Standard get Methods
  // TODO: Add Set Methods
  // TODO: maybe a move() function so the pickups move around the screen instead of being static
  int getX(){
    return x;
  }
  
  int getY(){
    return y;
  }
  
  int getRadius(){
    return radius;
  }
  
  int getFrameCreated(){
    return frameCreated;
  }
  
  // Standard toString() method, represents Object in human readable Form. Useful for debugging and logging
  String toString(){
    return "X: " + x + " Y: " + y + " RADIUS: " + radius + " Frame created: " + frameCreated;
  }
  
  
}

// A ColorPickup Object
class ColorPickup extends Pickup{
  int r, g, b;
  // Default constructor (no arguments)
  ColorPickup() {
    super();
    
    // Initialize random RGB Values
    r = int(random(255));
    g = int(random(255));
    b = int(random(255));
  }
  
  @Override void display(){
    noStroke();
    fill(r,g,b);
    ellipse(x,y,radius,radius);
  }
  
  
  // Standard get methods for all Variables
  int getR(){
    return r;
  }
  
  int getG(){
    return g;
  }
  
  int getB(){
    return b;
  }
  
  
  // Standard Function that returns all variables as a String, mainly used for debugging
  @Override String toString(){
    return "X: " + x + " Y: " + y + " Radius: " + radius +  " R: " + r + " G: " + g + " B: " + b + " Frame created: " + frameCreated;
  }
  
}

class SizePickup extends Pickup {
  int sizeChange;
  
  // Default Constructor with no Argument
  SizePickup(){
    super();
    
    // Initialize sizeChange by -20 or +20, picked randomly
    Random rd = new Random();
    
    if(rd.nextBoolean()){
      sizeChange = 20;
    }
    else{
      sizeChange = -20;
    }
    
  }
  
  // Draws Pickup on Screen
  // TODO: Fix Triangle Weirdness
  @Override void display(){
    fill(0);
    
    // Decreasing Brush Size: Triangle Down
    if(sizeChange < 0){
      triangle(x-10,y-radius/4,x+10,y-radius/4,x,y+radius/4);
    }
    // Increasing Brush Size: Triangle UP
    else{
      triangle(x-10,y+radius/4,x+10,y+radius/4,x, y-radius/4);
    }
    
    // Draw Outer Ring
    stroke(0);
    strokeWeight(4);
    noFill();
    ellipse(x,y,radius,radius);
    
  }
  
  //Standard get Methods for retrieving variables
  int getSizeChange(){
    return sizeChange;
  }
  
  //Standard Function that returns all variables as a String, mainly used for debugging
  @Override String toString(){
    return "X: " + x + " Y: " + y + " Radius: " + radius +  " Size change:" + sizeChange + " Frame created: " + frameCreated;
  }
  
  
}