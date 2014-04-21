// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Android

// accelerometer 
import android.content.Context;               
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;


//Networking Library
import oscP5.*;
import netP5.*;

//Import additional processing function into android
import apwidgets.*;
import android.text.InputType;
import android.view.inputmethod.EditorInfo;

APWidgetContainer widgetContainer; 
APEditText nameField, passwordField;

//using PImage to set up login
PImage login;

//Player Information
ArrayList playerInfo;

//global variables
boolean enteringInfo;

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

void setup()
{

  //set resolution and orientation of device
  size(displayWidth, displayHeight, P2D); 
  orientation(LANDSCAPE);
  frameRate(60);

  //initalize the container
  widgetContainer = new APWidgetContainer(this); //create new container for widgets

  //create a name textBox
  nameField = new APEditText(displayWidth/2 - 125, displayHeight/2 - 120, 290, 45); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(nameField);
  nameField.setInputType(InputType.TYPE_CLASS_TEXT); //Set the input type to text
  nameField.setImeOptions(EditorInfo.IME_ACTION_NEXT); //Enables a next button, shifts to next field

  //create a password text box
  passwordField = new APEditText(displayWidth/2 - 125, displayHeight/2 - 40, 290, 45); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(passwordField);
  passwordField.setInputType(InputType.TYPE_CLASS_TEXT); //set input type to text
  passwordField.setImeOptions(EditorInfo.IME_ACTION_DONE);
  passwordField.setCloseImeOnDone(true);
  
  //initalize the arraylist to store playerInfo
  playerInfo = new ArrayList();
  
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
  pOneCenter = (int)(25 + playerOne.size*10)/2;
  
}

void draw()
{
  //Load Starting Screen
  if(enteringInfo == true)
  {
    login = loadImage("login.png");
    image(login, 0, 0, displayWidth, displayHeight);
  }
  else
  {
    //after user info is entered
    //draw black background for game
     background(0);
     
     //displays username
     displayUsername(); 
     
     //unit collison.
     unitCollison();
     //Create the Player Cube
    // playerUnit();
     playerOne.run();
     
     //draw till maximum food is reached
     if(maxFood == false)
     {
        generateFood();
     }
     
     //place food around the board
     for(int i = 0; i < 4; ++i)
     {
        shape(myFood[i], xCoord[i], yCoord[i]);
     }
     
     //unit collison.
     unitCollison();
     
     //This is for testing collison and stuff remove
     //after we are finsh testing the game.
    // text(displayWidth , 500, 500);
    // text(displayHeight, 500 , 550);
    // text(x, 500, 600);
     //text(y, 500, 650);
    // text(playerOne.x, 500 , 400);
    // text(playerOne.y, 500 , 450);

  }
}

//When setCloseImeOnDone is finished it will call this which will close down the login screen
void onClickWidget(APWidget widget)
{
  if(widget == passwordField)
  {
    widgetContainer.removeWidget(nameField);
    widgetContainer.removeWidget(passwordField);
    enteringInfo = false;
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
  pOneCenter = (int)(25 + playerOne.size*10)/2; // makes sure the bounds are updated before checking for collision.
  
  for(int i = 0; i < 4; ++i)
  {
    if((playerOne.x  > xCoord[i]/2 - pOneCenter - 2 && playerOne.x < xCoord[i]/2 + pOneCenter + 2) 
        && (playerOne.y  > yCoord[i]/2 - pOneCenter - 2 && playerOne.y  < yCoord[i]/2 + pOneCenter + 2))
    {
       food = createShape(RECT, 0, 0, 10, 10);
       food.setFill(color(255,0,0));
       xCoord[i] = random(15, displayWidth - 70);
       yCoord[i] = random(15, displayHeight - 60);
       myFood[i] = food;
       print("hit! " + " xCoord[i]: " + xCoord[i] + " yCoord[i]: "+ yCoord[i]);
       
       playerOne.size = playerOne.size + 1;


    }
  }
}


//Creates the food pellets for the players to eat
void generateFood()
{
  for(int i = 0; i < 4; ++i)
  {
   food = createShape(RECT, 0, 0, 10, 10);
   food.setFill(color(255,0,0));
   xCoord[i] = random(15, displayWidth - 70);
   yCoord[i] = random(15, displayHeight - 60);
   myFood[i] = food;
   numFood++;
   print("i: " + i + " xCoord[i]: " + xCoord[i] + " yCoord[i]: "+ yCoord[i] + "\n");
   if (numFood == 4)
   {
     maxFood = true;
   }
  }
}

