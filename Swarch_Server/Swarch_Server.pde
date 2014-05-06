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
import de.bezier.data.sql.*;
SQLite db;

// listeningPort is the port the server is listening for incoming messages
int myListeningPort = 32000;
// the broadcast port is the port the clients should listen for incoming messages from the server
int myBroadcastPort = 12000;

//Used to check messages being sent and for the event 
// checker to identify what is going on.
//* Use this to check message for collison, username, and etc in the future
String myConnectPattern = "Connecting...";
String myDisconnectPattern = "/server/disconnect";

//Variable used to store userName/passWord sent from Client
//Use this to insert/compare to the database
String userName;
String passWord;


void setup() 
{
  //networking
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(60);



  //Database
  db = new SQLite(this, "account.db"); //opens the account database file
  if (db.connect())
   {
   //insert player test
   //db.query(" insert into table1 values ('anthony', '123')");
   
   //deleting players
   db.query("delete from table1 where Player = 'john' AND password = '000'");
   db.query("delete from table1 where Player = 'nike39' AND password = '000'");
   //db.query("delete from table1 where Player = 'thomas' AND password = '123'");
   
   //list table names?
   db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );
   
   while (db.next ())
   {
   println( db.getString("Name") );
   }
   
   //read from "table1"
   db.query( "SELECT * FROM table1" );
   
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
    oscP5.send(m, myNetAddressList);
  }
  else if (theOscMessage.addrPattern() != db.getString("Player"))
  {
    /*if (db.connect())
    {
      db.query("insert into table1 values ('" +theOscMessage.addrPattern()+"', '000')");
      db.query( "SELECT * FROM table1" );
      while (db.next ())
      {
        print("Username: " + db.getString("Player") + " Password: " + db.getString("Password"));
        println();
      }
    }*/
  }
  /* else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) 
   {
   disconnect(theOscMessage.netAddress().address());
   }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  /*else 
   {
   
   oscP5.send(theOscMessage, myNetAddressList);
   }*/
}


private void connect(String theIPaddress) 
{
  if (!myNetAddressList.contains(theIPaddress, myBroadcastPort)) 
  {
    myNetAddressList.add(new NetAddress(theIPaddress, myBroadcastPort));
    println("### adding "+theIPaddress+" to the player list.");
  } 
  else 
  {
    println("### "+theIPaddress+" is already connected.");
  }
  println("### currently there are "+myNetAddressList.list().size()+" remote locations connected.");
}



private void disconnect(String theIPaddress) 
{
  if (myNetAddressList.contains(theIPaddress, myBroadcastPort)) 
  { 
    myNetAddressList.remove(theIPaddress, myBroadcastPort);
    println("### removing "+theIPaddress+" from the list.");
  } 
  else 
  {
    println("### "+theIPaddress+" is not connected.");
  }
  println("### currently there are "+myNetAddressList.list().size());
}

