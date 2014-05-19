// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Androi - Java Server

/*
 * OscP5 and NetP5 Protocols used to setup the server
 * @NetAddressList - stores players IP
 */
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
Database datab;

//global variables
int food;
boolean foodMax;
float[] xCoord;
float[] yCoord;
float displayw, displayh;

//amount of players playing
int players = 0;
/*
 * @int myListeningPort - set server incoming message port to 32000
 */
int myListeningPort = 32000;


/*
 * @String myConnectPattern - Message server look for from client to connect
 * @String myDisconnectPattern - Message server look for from client to disconnect
 */
String myConnectPattern = "Connecting...";
String myDisconnectPattern = "Disconnecting...";

/*
 * @String userName - string variable that store userName from db.getString()
 * @String passWord - string variable that stores password from db.getString()
 */
String userName;
String passWord;


void setup() 
{
  food = 0;
  //initalize array to hold their x, y coord
  xCoord = new float[4];
  yCoord = new float[4];
  /*
   * Creates a new oscP5 Instance using myListening Port
   * and is in TCP mode
   */
  oscP5 = new OscP5(this, myListeningPort, OscP5.TCP);
  frameRate(60);
  datab = new Database(this);

  datab.connect();
}

void draw() 
{
  background(0);
}



//Creates the food pellets for the players to eat
void generateFood()
{
  for (; food < 4; food++)
  {
    xCoord[food] = random(15, displayw - 70);
    yCoord[food] = random(15, displayh - 60);
  }
}


void oscEvent(OscMessage theOscMessage)
{

  /* Check to see if client messages fits any of the server patterns */
  if (theOscMessage.addrPattern().equals(myConnectPattern)) 
  {
    connect(theOscMessage.netAddress().address());

    //testing send message was successful
    OscMessage m = new OscMessage("Connection Successful!");
    //This sends the above message to all clients connected.
    oscP5.send(m, theOscMessage.tcpConnection());
  }
  //handles user registration
  //check that if incoming message is not blank run the code inside
  else if (!theOscMessage.get(0).stringValue().equals(""))
  {
    if (datab.isConnected())
    {

      userName = datab.userName(theOscMessage.get(0).stringValue());
      passWord = datab.password(theOscMessage.get(0).stringValue(),theOscMessage.get(1).stringValue());
      println(userName + " " + passWord);
      
      //trying to access database but is not connected
      if(userName == "Databaseisnotconnected" && passWord == "Databaseisnotconnected")
      {
       println("Database is not connected"); 
      }
      /*
       * if Player doesn't exist in the database
       * print out a comment to console giving current state
       * Insert into table the current userName/Password from client
       * Send to client a Successful registration and start the game
       */
      else if (userName == null) 
      {
        println("Player is not in the database yet");
        //add player
        datab.addToDb(theOscMessage.get(0).stringValue(),theOscMessage.get(1).stringValue());
        println("addded " + theOscMessage.get(0).stringValue() + " " + theOscMessage.get(1).stringValue());
        OscMessage m2 = new OscMessage("Authenticated");
        oscP5.send(m2, theOscMessage.tcpConnection());
      }
      /*
       * if both userName and Password are correct
       * print to console giving current state
       * then the player exist in the database that matches the criteria
       * authenticate the player and continue on to the game
       */
      else if (userName != null && passWord != null)
      {
        println("Player Exist and Password Match");
        if(players < 2)
        {
          if(players == 0)
          {
            displayw = theOscMessage.get(2).intValue();
            displayh = theOscMessage.get(3).intValue();
          }
          generateFood();
          //authenticate player
          OscMessage m2 = new OscMessage("Authenticated");
          m2.add(xCoord[0]); m2.add(xCoord[1]); m2.add(xCoord[2]); m2.add(xCoord[3]);
          m2.add(yCoord[0]);m2.add(yCoord[1]);m2.add(yCoord[2]);m2.add(yCoord[3]);
          oscP5.send(m2, theOscMessage.tcpConnection());
          players++;
          
        }
      }
      /*
       * If player exist but the incorrect password is given
       * print to console giving current state
       * send to client that an incorrect password was given
       * client will handle a try again password field
       */
      else if (userName != null && passWord == null)
      {
        println("Player Exist, but Password Doesn't Match");
        //send login screen again
        OscMessage m3 = new OscMessage("Incorrect Password");
        oscP5.send(m3, theOscMessage.tcpConnection());
      }
    }
  }

  //commented out for milestone 4
  /*//Disocnnection function
   else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) 
   {
   disconnect(theOscMessage.netAddress().address());
   }
   //if none of above match than message all clients.
   else 
   {
   oscP5.send(theOscMessage, theOscMessage.tcpConnection());
   }*/
}


/*
 * Handles new players connecting
 * If player isn't in the player ip address list
 * they are added. Otherwise they are connected.
 */
private void connect(String theIPaddress) 
{
  if (!myNetAddressList.contains(theIPaddress, myListeningPort)) 
  {
    myNetAddressList.add(new NetAddress(theIPaddress, myListeningPort));
    println("### adding "+theIPaddress+" to the player list.");
  } 
  else 
  {
    println("### "+theIPaddress+" is already connected.");
  }
  println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
}


/*
private void disconnect(String theIPaddress) 
{
  if (myNetAddressList.contains(theIPaddress, myListeningPort)) 
  { 
    myNetAddressList.remove(theIPaddress, myListeningPort);
    println("### removing "+theIPaddress+" from the list.");
  } 
  else 
  {
    println("### "+theIPaddress+" is not connected.");
  }
  println("### currently there are "+myNetAddressList.list().size());
}*/

