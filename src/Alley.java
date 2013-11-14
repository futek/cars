public class Alley {
	private int n = 0; // number of cars in alley
	private int wt = 0; // number of cars waiting at top
	private int wb = 0; // number of cars waiting at bottom
	private boolean down = true; // last observed travel direction

	private boolean goesDown(int no) {
		return no < 5;
	}

	// TODO: Fix deadlock...

	public synchronized void enter(int no) throws InterruptedException {
		boolean goesDown = goesDown(no);

		if (goesDown) wt++; else wb++;

		while ((n > 0 && goesDown != down) || (goesDown ? wb > 0 : wt > 0)) {
		    wait();
		    if (n == 0 && down != goesDown) break;
		}

		if (goesDown) wt--; else wb--;

		n++;
		down = goesDown;
	}

	public synchronized void leave(int no) {
	    n--;
	    if (n == 0) notifyAll();
	}
}