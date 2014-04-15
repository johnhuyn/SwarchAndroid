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
int wScale1, hScale1,  hScale2;

void setup()
{

  //set resolution and orientation of device
  size(displayWidth, displayHeight); 
  wScale1 = ((displayWidth/2) - 125)*(1+(displayWidth/1920));
  hScale1 = ((displayHeight/2) - 120)*(1+(displayHeight/1080));
  hScale2 = ((displayHeight/2) - 40)*(1+(displayHeight/1080));

  orientation(LANDSCAPE);

  //initalize the container
  widgetContainer = new APWidgetContainer(this); //create new container for widgets

  //create a name textBox
  nameField = new APEditText(wScale1, hScale1, 150, 50); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(nameField);
  nameField.setInputType(InputType.TYPE_CLASS_TEXT); //Set the input type to text
  nameField.setImeOptions(EditorInfo.IME_ACTION_NEXT); //Enables a next button, shifts to next field


  //create a password text box
  passwordField = new APEditText(wScale1, hScale2, 150, 50); //create a textfield from x- and y-pos., width and height
  widgetContainer.addWidget(passwordField);
  passwordField.setInputType(InputType.TYPE_CLASS_TEXT); //set input type to text
  passwordField.setImeOptions(EditorInfo.IME_ACTION_DONE);
  passwordField.setCloseImeOnDone(true);
  
  //initalize the arraylist.
  playerInfo = new ArrayList();
  
  
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
  }
  
  displayUsername(); //displays username
  
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
  text("Password: " + passwordField.getText(), 10, 70); //testing purposes only
}

