import java.util.ArrayList;
import java.time.LocalTime;
import processing.net.*;


Client c;

int playerCount;
JSONArray json;
JSONArray playerMapJson;

ArrayList<Player> playerList;

Player myPlayer;

LocalTime lt = LocalTime.now();
// ArrayList<Player> playerList;
// ArrayList<Pickup> pickupList;

void setup(){
    size(1000, 1000);
    frameRate(30);
    background(255);

    c = new Client(this, "127.0.0.1", 4048);
    myPlayer = new Player(lt.hashCode());

    playerList = new ArrayList<Player>();
}

void draw(){

    // Send myself to Server
    myPlayer.setXY(mouseX, mouseY);
    c.write(myPlayer.getShortJson().toString());
    
    // Clear Playerlist and PickupList
    playerList.clear();

    // Read JSON from Server
    if(c.available() > 0){
        json = parseJSONArray(c.readString());
        
        playerMapJson = json.getJSONArray(0);

        for (int i = 0; i < playerMapJson.size(); i++){
            playerList.add(new Player(playerMapJson.getJSONObject(i)));
        }

        println(json.toString());
    }

    
    // Display Players

    for (Player p : playerList){
        if(p.getId() == myPlayer.getId()){

            myPlayer.display();
        }else{
            p.display();
        }
    }

    drawFade();
    
   
    
}

void drawFade(){
    fill(255,255,255,40);
    rect(0,0,width,height);
}
