public class Alley {
	private Semaphore empty= new Semaphore(1);

	// TODO: Allow multiple cars in same direction

	public void enter(int no) {
		try { empty.P(); } catch (InterruptedException e) {};
	}

	public void leave(int no) {
		empty.V();
	}
}