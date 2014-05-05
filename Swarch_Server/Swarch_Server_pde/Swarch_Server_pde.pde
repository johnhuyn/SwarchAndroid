// John Nguyen 
// Thomas Truong
// Anthony So
// ICS 168 Swarch on Android Client

//Networking Library
import processing.net.*;
Server myServer;
int val = 0;

void setup() {
  size(200, 200);
  // Starts a myServer on port 1337
  myServer = new Server(this, 1337); 
}

void draw() {
  val = (val + 1) % 255;
  background(val);
  myServer.write(val);
}
