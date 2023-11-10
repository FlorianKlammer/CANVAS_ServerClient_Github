// TODO: ADD Player Class
// TODO: ADD Pickup Class
// TODO: Write parsePlayerJSON() and parsePickupJSON()
// TODO: Write writePlayerJSON() and writePickupJSON()


import processing.net.*;
import java.util.*;

import java.util.Random;

int i, id, x, y; 
Server s;
Player p;

HashSet<Client> clientSet;
HashMap<Integer, Player> playerMap;
ArrayList<Pickup> pickupList;


JSONArray serverJson;
JSONArray playerMapJson;
JSONArray pickupListJson;

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
    // The id seems unneccessary since it never changes but for time reasons i'm not making it more efficient
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

                    // Pickup Collision Detection
                    for (Iterator<Pickup> it = pickupList.iterator(); it.hasNext();){
                        Pickup pickup = it.next();
                        if(pickup.collision(x,y, p.getBrushSize())){
                            println("True");
                            String type = pickup.getType();

                            if (type.equals("Color")){
                                ColorPickup cp = (ColorPickup)pickup;

                                p.setBrushR(cp.getR());
                                p.setBrushG(cp.getG());
                                p.setBrushB(cp.getB());

                            } else if (type.equals("Size")){
                                SizePickup sp = (SizePickup)pickup;

                                p.setBrushSize(p.getBrushSize()+sp.getSizeChange());
                            }

                            it.remove();
                        }
                    }
                }
                
            }
        }
    }

    // Initialize empty JSONArray which will store all the Pickup Data for sending to the Client
    pickupListJson = new JSONArray();
    i = 0;

    // Loops through all Pickups and adds them to pickupListJSON
    if(pickupList.size()>0){
        for(Pickup p : pickupList){
            pickupListJson.setJSONObject(i, p.getJSON());
            i++;
            
            p.display();
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

    
    

    // Initialize final JSONArray which gets sent to the Client, includes all Players and Pickups
    serverJson = new JSONArray();
    serverJson.setJSONArray(0, playerMapJson);
    serverJson.setJSONArray(1, pickupListJson);
    

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