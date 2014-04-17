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
String name = "";
String password = "";
boolean enteringInfo = true;

//Shape
PShape square;
PShape food;

//movement
float x, y;

//food
int numFood = 0;
boolean maxFood = false;
PShape[] myFood; 
int[] xCoord;
  int[] yCoord;

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
  
  //initalize the arraylist.
  playerInfo = new ArrayList();
  myFood = new PShape[4];
  xCoord = new int[4];
  yCoord = new int[4];
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
     
     playerUnit();
     
      if(maxFood == false)
     {
       generateFood();
     

     }
   
    for(int i = 0; i < 4; ++i)
       {
         shape(myFood[i], xCoord[i], yCoord[i]);
       
       }
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

//display User name in top left corner
void displayUsername()
{
  fill(255);
  textSize(25);
  text("User: " + nameField.getText(), 10, 30);
  text("Score: ", displayWidth - 200, 30);
}

void mouseDragged()
{
  if(x > -25 && x < displayWidth - 25 && y > 5 && y < displayHeight)
  {
    x = mouseX;
    y = mouseY;
  }
  else
  {
    x = displayWidth/2;
    y = displayHeight/2;
  }
  
}
void playerUnit()
{
  square = createShape(RECT, 0,0, 50, 50);
  square.setFill(color(255,255,0));
  shape(square, x, y);
  
}

void generateFood()
{
  for(int i = 0; i < 4; ++i)
  {
   food = createShape(RECT, 0, 0, 10, 10);
   food.setFill(color(255,0,0));
   xCoord[i] = (int)random(0,displayWidth);
   yCoord[i] = (int)random(0, displayHeight);
   myFood[i] = food;
   numFood++;
   if (numFood == 4)
     maxFood = true;
  }
}

