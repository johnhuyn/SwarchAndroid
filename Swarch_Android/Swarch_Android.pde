
// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Android

//Networking Library
import oscP5.*;
import netP5.*;


void setup()
{

  size(displayWidth, displayHeight);
  orientation(LANDSCAPE);
  background(255);
  
}

void draw()
{
  displayUsername();
}

String askUser()
{
  //String id = showInputDialog("Enter a Username:");
  

  return "a";
}


void displayUsername()
{
  fill(0);
  textSize(25);
  text("User: " + "Mistax" , 10, 30);
}

