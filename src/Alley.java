public class Alley {
	private Semaphore freeTop = new Semaphore(1);
	private Semaphore freeBot = new Semaphore(1);
	private int n = 0;

	// TODO: Allow multiple cars in same direction

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
		if (goesDown(no)) {
			try { freeTop.P(); } catch (InterruptedException e) {};

			if (n == 0) {
				try { freeBot.P(); } catch (InterruptedException e) {};
			}

			n++;

			freeTop.V();
		} else {
			try { freeBot.P(); } catch (InterruptedException e) {};

			if (n == 0) {
				try { freeTop.P(); } catch (InterruptedException e) {};
			}

			n++;

			freeBot.V();
		}
	}

	public void leave(int no) {
		n--;

		if (n == 0) {
			if (goesDown(no)) {
				freeBot.V();
			} else {
				freeTop.V();
			}
		}
	}
}