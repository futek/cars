public class Alley {
    private Semaphore mutex = new Semaphore(1);
    private Semaphore top = new Semaphore(0);
    private Semaphore bot = new Semaphore(0);

    private int n = 0; // number of cars in alley
    private int w = 0; // number of cars waiting
    private boolean down = true; // last observed travel direction

    private boolean goesDown(int no) {
        return no < 5;
    }

    public void enter(int no) throws InterruptedException {
        boolean goesDown = goesDown(no);
        Semaphore a = goesDown ? top : bot;

        while (true) {
            mutex.P();
            if (n == 0 || goesDown == down)
                break;
            w++;
            mutex.V();
            a.P();
        }
        n++;
        down = goesDown;
        mutex.V();
    }

    public void leave(int no) throws InterruptedException {
        boolean goesDown = goesDown(no);
        Semaphore b = goesDown ? bot : top;

        mutex.P();
        n--;
        if (n == 0) {
            while (w > 0) {
                w--;
                b.V();
            }
        }
        mutex.V();
    }
}