public class Alley {
    private Semaphore mutex = new Semaphore(1);
    private Semaphore wait = new Semaphore(0);

    private int n = 0; // number of cars in alley
    private int w = 0; // number of cars waiting
    private boolean down = true; // last observed travel direction

    private boolean goesDown(int no) {
        return no < 5;
    }

    public void enter(int no) throws InterruptedException {
        boolean goesDown = goesDown(no);

        while (true) {
            mutex.P();
            if (n == 0 || goesDown == down) break;
            w++;
            mutex.V();
            wait.P();
        }

        n++;
        down = goesDown;

        mutex.V();
    }

    public void leave(int no) throws InterruptedException {
        mutex.P();

        n--;
        if (n == 0) {
            while (w > 0) {
                w--;
                wait.V();
            }
        }

        mutex.V();
    }
}