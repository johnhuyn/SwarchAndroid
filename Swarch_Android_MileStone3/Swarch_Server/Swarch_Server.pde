// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Androi - Java Server

//Swarch Server - send and rceieves player information
import oscP5.*;
import netP5.*;
OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();

//SQLite DB
import java.sql.*;
import de.bezier.data.sql.*;
SQLite db;

// listeningPort is the port the server is listening for incoming messages
int myListeningPort = 32000;
// the broadcast port is the port the clients should listen for incoming messages from the server
//int myBroadcastPort = 12000;

//Used to check messages being sent and for the event 
// checker to identify what is going on.
//* Use this to check message for collison, username, and etc in the future
String myConnectPattern = "Connecting...";
String myDisconnectPattern = "Disconnecting...";

//Variable used to store userName/passWord sent from Client
//Use this to insert/compare to the database
String userName;
String passWord;


void setup() 
{
  //networking set in tcp mode
  oscP5 = new OscP5(this, myListeningPort, OscP5.TCP);
  frameRate(60);

  //Database
  db = new SQLite(this, "account.db"); //opens the account database file

  if (db.connect())
  {
    //insert player test
    //db.query(" insert into table1 values ('anthony', '123')");

    //deleting players example
    //db.query("delete from table1");

    //list table names
    /*db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );
     
     while (db.next ())
     {
     println( db.getString("Name") );
     }*/

    //read from "table1"
    db.query( "SELECT * FROM table1" );
    //print("Username: " + db.getString("Player") + " Password: " + db.getString("Password"));

    while (db.next ())
    {
      print("Username: " + db.getString("Player") + " Password: " + db.getString("Password"));
      println();
    }
  }
}

void draw() 
{
  background(0);
}

void oscEvent(OscMessage theOscMessage)
{

  /* check if the address pattern fits any of our patterns */
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
    //simple solution is to prevent duplicate entries.
    //added unique player column
    if (db.connect())
    {
      //Look for userName in Player
      db.query("SELECT * FROM table1 where player = '" +theOscMessage.get(0).stringValue() +"'");
      userName = db.getString("Player");
      db.query("SELECT * FROM table1 where player = '" +theOscMessage.get(0).stringValue() +"' and password = '" + theOscMessage.get(1).stringValue() + "'");
      passWord = db.getString("Password");
      println(userName + " " + passWord);

      if (userName == null) //If the message matches than it return true
      {
        println("Player is not in the database yet");
        //add player
        db.query("INSERT into table1 values ('"+theOscMessage.get(0).stringValue()+"', '"+theOscMessage.get(1).stringValue()+"')");
        println("addded " + theOscMessage.get(0).stringValue() + " " + theOscMessage.get(1).stringValue());
        OscMessage m2 = new OscMessage("Authenticated");
        oscP5.send(m2, theOscMessage.tcpConnection());
      }
      else if (userName != null && passWord != null)
      {
        println("Player Exist and Password Match");
        //authenticate player
        OscMessage m2 = new OscMessage("Authenticated");
        oscP5.send(m2, theOscMessage.tcpConnection());
      }
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


//connects player to server and store them in IP address list
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


//finish implementing latter
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
}

