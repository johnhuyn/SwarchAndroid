// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Android

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
     
     //Create the Player Cube
     playerUnit();
     
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
     text(displayWidth , 500, 500);
     text(displayHeight, 500 , 550);
     text(x, 500, 600);
     text(y, 500, 650);
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
  text("Score: ", displayWidth - 200, 30);
}

//Player touchscreen control.
//Still buggy with bottom y and right side x collison
void mouseDragged()
{
  if((x > 15 && x < displayWidth - 70) && (y > 15 && y < displayHeight - 60))
  {
    x = mouseX;
    y = mouseY;
  }
  else
  {
    x = random(15, displayWidth - 70);
    y = random(15, displayHeight - 60);
    
    //Reset the player cube to it's original size when dying
    square = createShape(RECT, 0,0, 50, 50);
  }
}

//creates the player square unit
void playerUnit()
{
  square = createShape(RECT, 0,0, 50, 50);
  square.setFill(color(255,255,0));
  shape(square, x, y);
}

//unit collison
//This semi works at the moment, but i need someone to go over this to make sure.
//Also need to remove pellet when collison happens.
boolean unitCollison()
{
  for(int i = 0; i < 4; ++i)
  {
    if(x > xCoord[i] - 10 || x < xCoord[i] + 20)
    {
      return true;
    }
    else if(y > yCoord[i] - 10 || y < yCoord[i] + 20)
    {
      return true;
    }
    else
    {
      return false;
    }
  }
  return false;
}

//Creates the food pellets for the players to eat
void generateFood()
{
  for(int i = 0; i < 4; ++i)
  {
   food = createShape(RECT, 0, 0, 10, 10);
   food.setFill(color(255,0,0));
   xCoord[i] = random(15,displayWidth - 70);
   yCoord[i] = random(15, displayHeight - 60);
   myFood[i] = food;
   numFood++;
   if (numFood == 4)
   {
     maxFood = true;
   }
  }
}

