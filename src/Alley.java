public class Alley {
	private int n = 0; // number of cars in alley
	private boolean down = true; // last observed travel direction

	private boolean goesDown(int no) {
		return no < 5;
	}

	public synchronized void enter(int no) {
		boolean goesDown = goesDown(no);

		if (n > 0 && goesDown != down) {
		    try { wait(); } catch (InterruptedException e) {}
		}

		n++;
		if (n == 1) down = goesDown;
	}

	public synchronized void leave(int no) {
	    n--;
	    if (n == 0) notifyAll();
	}
}