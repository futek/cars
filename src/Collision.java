import java.util.HashMap;
import java.util.Map;

public class Collision {
	private Map<Pos, Semaphore> empty = new HashMap<Pos, Semaphore>();

	public Collision(int rows, int cols) {
		for (int row = 0; row < rows; row++) {
        	for (int col = 0; col < cols; col++) {
        		empty.put(new Pos(row, col), new Semaphore(1));
        	}
        }
	}

	public void enter(Pos pos) {
		try { empty.get(pos).P(); } catch (InterruptedException e) {};
	}

	public void leave(Pos pos) {
		empty.get(pos).V();
	}
}