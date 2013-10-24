public class Alley {
	private Semaphore freeTop = new Semaphore(1);
	private Semaphore freeBot = new Semaphore(1);
	private int n = 0;

	// TODO: Solve deadlock where both top and bottom enter at the same time!

	/*
	 *              <
	 *           | |
	 *           | |
	 *           |V|
	 *           | |
	 *           |V|
	 *              <
	 */

	public boolean goesDown(int no) {
		return no < 5;
	}

	public void enter(int no) {
		Semaphore our = (goesDown(no) ? freeTop : freeBot);
		Semaphore their = (!goesDown(no) ? freeTop : freeBot);

		try { our.P(); } catch (InterruptedException e) {};

		if (n == 0) {
			try { their.P(); } catch (InterruptedException e) {};
		}

		n++;

		our.V();
	}

	public void leave(int no) {
		Semaphore our = (goesDown(no) ? freeTop : freeBot);
		Semaphore their = (!goesDown(no) ? freeTop : freeBot);

		try { our.P(); } catch (InterruptedException e) {};

		n--;

		if (n == 0) {
			their.V();
		}

		our.V();
	}
}