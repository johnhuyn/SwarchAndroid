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

/*
 * SQLite DB
 * Uses BezierSQLib for Processing
 */
import java.sql.*;
import de.bezier.data.sql.*;
SQLite db;

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
  /*
   * Creates a new oscP5 Instance using myListening Port
   * and is in TCP mode
   */
  oscP5 = new OscP5(this, myListeningPort, OscP5.TCP);
  frameRate(60);

  /*
   * Creates a instance of SQLite that opens
   * an account database file which currently
   * holds a table "table1" and "player" 
   * and "password" columns
   */
  db = new SQLite(this, "account.db"); //opens the account database file

  if (db.connect())
  {

    //Example of how to insert into table
    //db.query(" insert into table1 values ('anthony', '123')");

    //How to delete the entire table1
    //db.query("delete from table1");

    //list table names
    db.query( "SELECT name as \"Name\" FROM SQLITE_MASTER where type=\"table\"" );

    while (db.next ())
    {
      println(db.getString("Name") );
    }

    //read from "table1"
    db.query( "SELECT * FROM table1" );

    //print out user and password in the database when server starts up.
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
    if (db.connect())
    {
      //Look for userName in Player and store it in userName
      db.query("SELECT * FROM table1 where player = '" +theOscMessage.get(0).stringValue() +"'");
      userName = db.getString("Player");
      //Query for a player and password that matches in both columns and store in passWord
      db.query("SELECT * FROM table1 where player = '" +theOscMessage.get(0).stringValue() +"' and password = '" + theOscMessage.get(1).stringValue() + "'");
      passWord = db.getString("Password");
      println(userName + " " + passWord);
      
      /*
       * if Player doesn't exist in the database
       * print out a comment to console giving current state
       * Insert into table the current userName/Password from client
       * Send to client a Successful registration and start the game
       */
     if (userName == null) 
      {
        println("Player is not in the database yet");
        //add player
        db.query("INSERT into table1 values ('"+theOscMessage.get(0).stringValue()+"', '"+theOscMessage.get(1).stringValue()+"')");
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
        //authenticate player
        OscMessage m2 = new OscMessage("Authenticated");
        oscP5.send(m2, theOscMessage.tcpConnection());
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

