
   SensorManager sensorManager;       // keep track of sensor
  SensorListener sensorListener;     // special class for noting sensor changes
  Sensor accelerometer;              // Sensor object for accelerometer
  float[] accelData;                 // x,y,z sensor data
  //1196
  //768
public class Player
{
  
  float x, y, xVelo, yVelo, size;
  int dir;
  
  public Player()
  {
      y = displayWidth/2;
      x = displayHeight/2;
      xVelo = 0;
      yVelo = 0;
      size = 0;
  }
  
  int direction()
  { 
    return dir;
  }
  float getX()
  {
    return x;
  }
  float getY()
  {
    return y;
  }
  
  void setX(float xpos)
  {
    x = xpos;
  }
  
  void setY(float ypos)
  {
    y = ypos;
  }
  
  void move()
  {  
    if(accelData != null)
    {
      xVelo = accelData[1];
      yVelo = accelData[0];
    }
   
       if(abs(xVelo) > abs(yVelo))
       {
         if(size > 0)
         {
           if(xVelo < 1)
           {
             x -= 1 * (1 - size/20);
             dir = 1; //moving left
           }
           else
           {
             x+= 1 * (1 - size/20);
             dir = -1; //moving right
           }
         }
         else
         {
           if(xVelo < 1)
           {
             x -= 1;
             dir = 1; // moving left
            // println("moving left");
           }
           else
           {
             x += 1;
             dir = -1; // moving right
            // println("moving right");
           }
         }
       }
       else
       {
         if(size > 0)
         {
           if(yVelo < 1)
           {
             y -= 1 * (1 - size/20);
             dir = -2;//moving up
           }
           else
           {
             y += 1 * (1 - size/20);
             dir = 2;//moving down
           }
         }
         else
         {
           if(yVelo < 1)
           {
             y -= 1;
             dir = -2;//moving up
             //println("moving up");
           }
           else
           {
             y += 1;
             dir = 2;//moving down
             //println("moving down");
           }
         }
       }
         
  }
  
  
  
  
  void display()
  {
    square = createShape(RECT, x, y, 25 + size*10, 25 + size*10);
    square.setFill(color(255,255,0));
    shapeMode(CENTER);
    shape(square, x, y);
  }
  
//    For Testing purposes:
//       player is able to move to edge; landing on the other side of the screen
//     -** Need to change later so that player dies; when hits edge.
/*   void edges()
   {
    if (x - (10) > displayHeight - 140) 
    {
        x = random(25, displayWidth - 70);
        y = random(25, displayHeight - 60);
        size = 0;
    }
    else if (x - 10 < 0)
    {
        x = random(25, displayWidth - 70);
        y = random(25, displayHeight - 60);
        size = 0;
    }
    else if (y + (10)> displayWidth/3 - 60)
    {
        x = random(25, displayWidth - 70);
        y = random(25, displayHeight - 60);
        size = 0;
    }
    else if (y - 10 < 0)
    {
        x = random(25, displayWidth - 70);
        y = random(25, displayHeight - 60);
        size = 0;
    }
  }
  */
  void run()
  {
    //edges();
    move();
    display();
  }
}

  void onResume()
  {
    super.onResume();
    sensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
    sensorListener = new SensorListener();
    accelerometer = sensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
    sensorManager.registerListener(sensorListener, accelerometer, SensorManager.SENSOR_DELAY_GAME);  // see top comments for speed options
  }
  
  void onPause() 
  {
    sensorManager.unregisterListener(sensorListener);
    super.onPause();
  }

class SensorListener implements SensorEventListener 
{
  
  void onSensorChanged(SensorEvent event) 
  {
    if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) 
    {
      accelData = event.values;
    }
  }
  
  void onAccuracyChanged(Sensor sensor, int accuracy) 
  {
    // nothing here, but this method is required for the code to work...
  }
  
}

