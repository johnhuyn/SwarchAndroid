
   SensorManager sensorManager;       // keep track of sensor
  SensorListener sensorListener;     // special class for noting sensor changes
  Sensor accelerometer;              // Sensor object for accelerometer
  float[] accelData;                 // x,y,z sensor data
  //1196
  //768
public class Player
{
  
  float x, y, xVelo, yVelo, size;
   
  public Player()
  {
      y = displayWidth/2;
      x = displayHeight/2;
      xVelo = 0;
      yVelo = 0;
      size = 0;
  }
  
  void move()
  {
    if(accelData != null)
    {
      xVelo = accelData[0];
      yVelo = accelData[1];
    }
   
       if(abs(xVelo) > abs(yVelo))
       {
         if(size > 0)
         {
           if(xVelo < 1)
           {
             x -= 1 * (1 - size/20);
           }
           else
           {
             x+= 1 * (1 - size/20);
           }
         }
         else
         {
           if(xVelo < 1)
           {
             x -= 1;
           }
           else
           {
             x += 1;
           }
         }
       }
       else
       {
         if(size > 0)
         {
           if(yVelo < 1)
           {
             y += 1 * (1 - size/20);
           }
           else
           {
             y -= 1 * (1 - size/20);
           }
         }
         else
         {
           if(yVelo < 1)
           {
             y += 1;
           }
           else
           {
             y -= 1;
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
   void edges()
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
  
  void run()
  {
    edges();
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

