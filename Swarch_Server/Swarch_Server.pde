// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Android Server on Java

/**
 * Swarch Server - send and rceieves player information
 */

import oscP5.*;
import netP5.*;

/**
 * SQLite DB
 */
import de.bezier.data.sql.*;

SQLite db;


OscP5 oscP5;
NetAddressList myNetAddressList = new NetAddressList();
/* listeningPort is the port the server is listening for incoming messages */
int myListeningPort = 32000;
/* the broadcast port is the port the clients should listen for incoming messages from the server*/
int myBroadcastPort = 12000;

String myConnectPattern = "UserName:";
String myDisconnectPattern = "/server/disconnect";


void setup() 
{
  //networking
  oscP5 = new OscP5(this, myListeningPort);
  frameRate(60);
  
  
    db = new SQLite( this, "test.db" );  // open database file

    if ( db.connect() )
    {
        // list table names
        db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );
        
        while (db.next())
        {
            println( db.getString("Name") );
        }
        
        // read all in table "table_one"
        db.query( "SELECT * FROM table_one" );
        
        while (db.next())
        {
            println( db.getString("field_one") );
            println( db.getInt("field_two") );
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
    OscMessage m = new OscMessage("faaggot");
    oscP5.send(m, myNetAddressList);
  }
  else if (theOscMessage.addrPattern().equals(myDisconnectPattern)) 
  {
    disconnect(theOscMessage.netAddress().address());
  }
  /**
   * if pattern matching was not successful, then broadcast the incoming
   * message to all addresses in the netAddresList. 
   */
  else 
  {

    oscP5.send(theOscMessage, myNetAddressList);
  }
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

