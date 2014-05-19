public class ThreadClients implements Runnable
{
  Thread thread;
  
  public ThreadClients()
  {
  }
  
  public void start()
  {
    thread = new Thread(this);
    thread.start();
  }
  
  public void run()
  {
  }
  
  public void checkCollision()
  {
    
  }
  
 void oscEvent(OscMessage theOscMessage)
 {
 }
 
}
