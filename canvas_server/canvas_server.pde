// TODO: ADD Player Class
// TODO: ADD Pickup Class
// TODO: Write parsePlayerJSON() and parsePickupJSON()
// TODO: Write writePlayerJSON() and writePickupJSON()


import processing.net.*;
import java.util.HashSet;
import java.util.HashMap;
import java.util.ArrayList;

import java.util.Random;

int i, id, x, y; 
Server s;
Player p;

HashSet<Client> clientSet;
HashMap<Integer, Player> playerMap;
ArrayList<Pickup> pickupList;


JSONArray serverJson;
JSONArray playerMapJson;

Random rd;

void setup(){
    size(1000,1000);
    frameRate(120);
    background(0);
    stroke(0);

    s = new Server(this, 4048);

    clientSet = new HashSet<Client>();
    playerMap = new HashMap<Integer, Player>();
    pickupList = new ArrayList<Pickup>();

    rd = new Random();

    createStartingPickups(8);
}


void draw(){
    noStroke();
    // Receive Data from all Clients, changes the Corresponding Players X,Y and id. 
    // The id seems unneccessary since it never changes but I haven't found a good way to do overcome this yet
    if(clientSet.size()>0){
        for (Client c : clientSet){
            // Check if Client has available Message
            if(c.available() > 0){

                // Check if Clients Corresponding Player exists
                if(playerMap.containsKey(c.hashCode())){
                    // Parse the Client Message into JSON Object and extract the Data out of it
                    JSONObject json = parseJSONObject(c.readString());

                    id = json.getInt("id");
                    x = json.getInt("x");
                    y = json.getInt("y");

                    
                    p = playerMap.get(c.hashCode());
                    p.setXY(x,y);
                    p.setId(id);
                }
                
            }
        }
    }


    // Initialize empty JSONArray which will store all the Player Data for sending to the Client
    playerMapJson = new JSONArray();
    i = 0;

    // Loops through all connected Players and adds them to playerMapJSON
    if(playerMap.size()>0){
        for (Player p : playerMap.values()){
            playerMapJson.setJSONObject(i, p.getJSON());
            p.display();
            i++;
           
        }
    }

    // DEBUG: Display Pickups on Server
    if(pickupList.size()>0){
        for(Pickup p : pickupList){
            p.display();
        }
    }

    // Initialize final JSONArray which gets sent to the Client, includes all Players and Pickups
    serverJson = new JSONArray();
    serverJson.setJSONArray(0, playerMapJson);
    

    //Write final JSON to Clients
    s.write(serverJson.toString());
    
}


// Create 8 new Random Pickups
void createStartingPickups(int amount){
    for(int i = 0; i < amount; i++){
        if(rd.nextBoolean()){
            pickupList.add(new ColorPickup()); 
        }else{
            pickupList.add(new SizePickup());
        }
    }
}





// serverEvent() is called whenever a Client connects to the Server
// In this case we save every Client in a Set and create a corresponding Player for it 
void serverEvent(Server someServer, Client someClient) {
  println("We have a new client: " + someClient.ip());
  clientSet.add(someClient);
  playerMap.put(someClient.hashCode(), new Player());
  println(someClient.hashCode());
}

// disconnectEvent() is called whenver a Client disconnects from the Server
// In this case we remove the Client and the corresponding Player from their Data Structures
void disconnectEvent(Client someClient){
    println("Removing Client: "+ someClient.ip());
    println(someClient.hashCode());
    clientSet.remove(someClient);
    
    // Remove correspondent Player from PlayerMap
    Player disconnectedPlayer = playerMap.get(someClient.hashCode());

    if(disconnectedPlayer != null){
        playerMap.remove(someClient.hashCode());
        println("Player for client " + someClient.ip() + " has been removed.");
    } else {
        println("No corresponding Player found for the disconnected client.");
    }
}