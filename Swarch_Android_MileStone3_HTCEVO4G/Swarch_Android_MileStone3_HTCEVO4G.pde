// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Android

//MD5 encryption
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Formatter;

// accelerometer 
import android.content.Context;               
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;

//key event
import android.view.InputEvent;
import android.view.KeyEvent;

//Networking Library
import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myBroadcastLocation; 

//Import additional processing function into android
import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;

APWidgetContainer widgetContainer; 
APEditText nameField, passwordField;

//using PImage to set up login
PImage login;

//Player Information
String userName;
String passWord;
String failPass;
String ip = "169.234.57.216";
//global variables
boolean enteringInfo;
int wScale1, hScale1,  hScale2;

//Shape
PShape square;
PShape food;

//movement
float x, y;

//Variable for food
int numFood;
boolean maxFood;
PShape[] myFood; 
float[] xCoord;
float[] yCoord;
Player playerOne;
int pOneCenter;

//multithread
ThreadThing tt;

void setup()
{

  //set resolution and orientation of device
  size(displayWidth, displayHeight, P2D); 
  orientation(LANDSCAPE);
  frameRate(60);
  wScale1 = ((displayWidth/2) - 85)*(1+(displayWidth/1920));
  hScale1 = ((displayHeight/2) - 85)*(1+(displayHeight/1080));
  hScale2 = ((displayHeight/2) - 35)*(1+(displayHeight/1080));

  //initalize the container
  widgetContainer = new APWidgetContainer(this); //create new container for widgets

    //create a name textBox
  nameField = new APEditText(wScale1, hScale1, 195, 55); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(nameField);
  nameField.setInputType(InputType.TYPE_CLASS_TEXT); //Set the input type to text
  nameField.setImeOptions(EditorInfo.IME_ACTION_NEXT); //Enables a next button, shifts to next field

  //create a password text box
  passwordField = new APEditText(wScale1, hScale2, 195, 55); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(passwordField);
  passwordField.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD); //set input type to text
  passwordField.setImeOptions(EditorInfo.IME_ACTION_DONE);
  passwordField.setCloseImeOnDone(true);


  //initalize array to hold Shapes and their x, y coord
  myFood = new PShape[4];
  xCoord = new float[4];
  yCoord = new float[4];

  //initalize maxFood
  maxFood = false;

  //initalize enteringInfo
  enteringInfo = true;

  //start a player at a random location
  x = random(15, displayWidth - 70);
  y = random(15, displayHeight - 60);

  playerOne = new Player();
  pOneCenter = (int)(25 + playerOne.size*10)/3;

  //Initialize network settings

  //listens for incoming messages
  oscP5 = new OscP5(this, ip, 32000, OscP5.TCP);

  //Connect to Server on start up
  OscMessage m3;
  m3 = new OscMessage("Connecting...", new Object[0]);
  oscP5.send(m3);// myBroadcastLocation);

  //Initalize Playerinfo
  userName = "";
  passWord = "";
  failPass = "";

  //init threading
  tt = new ThreadThing(this);
}

void draw()
{
  //Load Starting Screen
  if (enteringInfo == true)
  {
    login = loadImage("login.png");
    image(login, 0, 0, displayWidth, displayHeight);

    //display failed attempt at login
    fill(255);
    textSize(25);
    text(failPass, 10, 30);
  }
  else
  {
    //after user info is entered
    //draw black background for game
    background(0);

    //displays username
    displayUsername(); 

    //unit collison.
    //unitCollison();
    //Create the Player Cube
    // playerUnit();
    playerOne.run();
    
    generateFood();
    //place food around the board
    for (int i = 0; i < 4; i++)
    {
      shape(myFood[i], xCoord[i], yCoord[i]);
    }

    //unit collison.
    //unitCollison();
  }
}

void generateFood()
{
   for(int i = 0; i < 4; i++)
   {
      food = createShape(RECT, 0, 0, 10, 10);
      food.setFill(color(255, 0, 0));
      myFood[i] = food;
   }
}

//When setCloseImeOnDone is finished it will call this which will close down the login screen
void onClickWidget(APWidget widget)
{
  if (widget == passwordField)
  { 
    widgetContainer.removeWidget(nameField);
    widgetContainer.removeWidget(passwordField);
    //start a new thread to handle username being sent to server
    //while android handles the key press event
    tt.start();
  }
}

//display User name  and score in top left and right corners
void displayUsername()
{
  fill(255);
  textSize(25);
  text("User: " + nameField.getText(), 10, 30);
  text("Score: " + playerOne.size, displayWidth - 200, 30);
}

void unitCollison()
{
  pOneCenter = (int)(25 + playerOne.size*10)/3; // makes sure the bounds are updated before checking for collision.

  for (int i = 0; i < 4; ++i)
  {
    if ((playerOne.x  > xCoord[i]/2 - pOneCenter - 2 && playerOne.x < xCoord[i]/2 + pOneCenter + 2) 
      && (playerOne.y  > yCoord[i]/2 - pOneCenter - 2 && playerOne.y  < yCoord[i]/2 + pOneCenter + 2))
    {
      food = createShape(RECT, 0, 0, 10, 10);
      food.setFill(color(255, 0, 0));
      xCoord[i] = random(15, displayWidth - 70);
      yCoord[i] = random(15, displayHeight - 60);
      myFood[i] = food;
      print("hit! " + " xCoord[i]: " + xCoord[i] + " yCoord[i]: "+ yCoord[i]);

      playerOne.size = playerOne.size + 1;
    }
  }
}

//listens for incoming messages from the server
void oscEvent(OscMessage theOscMessage) 
{
  if (theOscMessage.addrPattern().equals("Authenticated"))
  {
    xCoord[0] = theOscMessage.get(0).floatValue();
    xCoord[1] = theOscMessage.get(1).floatValue();
    xCoord[2] = theOscMessage.get(2).floatValue();
    xCoord[3] = theOscMessage.get(3).floatValue();
    yCoord[0] = theOscMessage.get(4).floatValue();
    yCoord[1] = theOscMessage.get(5).floatValue();
    yCoord[2] = theOscMessage.get(6).floatValue();
    yCoord[3] = theOscMessage.get(7).floatValue();
    enteringInfo = false;
  }
  else if (theOscMessage.addrPattern().equals("Incorrect Password"))
  {
    failPass = "Incorrect Password";
    enteringInfo = true;
    widgetContainer.addWidget(nameField);
    widgetContainer.addWidget(passwordField);
  }
}

