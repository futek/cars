public class Alley {
  private int n = 0; // number of cars in alley
  private int wt = 0; // number of cars waiting at top
  private int wb = 0; // number of cars waiting at bottom
  private boolean down = true; // last observed travel direction

  private boolean goesDown(int no) {
    return no < 5;
  }

  private boolean allowedToEnter(boolean goesDown) {
    boolean emptyAndNewDirection = n == 0 && down != goesDown;
    boolean emptyOrSameDirection = n == 0 || goesDown == down;
    boolean noCarsWaiting = goesDown && wb == 0 || !goesDown && wt == 0;

    return emptyAndNewDirection || emptyOrSameDirection && noCarsWaiting;
  }

  public synchronized void enter(int no) throws InterruptedException {
    boolean goesDown = goesDown(no);

    if (goesDown) wt++; else wb++;
    while (!allowedToEnter(goesDown)) wait();
    if (goesDown) wt--; else wb--;

    n++;
    down = goesDown;
  }

  public synchronized void leave(int no) {
    n--;
    if (n == 0) notifyAll();
  }
}