public class Barrier {
    private boolean on = false;
    private int numberOfCars;
    private Semaphore mutex = new Semaphore(1);
    private Semaphore wait = new Semaphore(0);
    private Semaphore next = new Semaphore(0);
    private int n = 0;
    private int w = 0;

    public Barrier(int numberOfCars) {
        this.numberOfCars = numberOfCars;
    }

    public void sync() throws InterruptedException {
        if (!on) return;

        mutex.P();

        n++;

        if (n < numberOfCars) {
            w++;
            mutex.V();
            wait.P();
            next.V();
            return;
        }

        for (n = 0; w > 0; w--) {
            wait.V();
            next.P();
        }

        mutex.V();
    }

    public void on() {
        on = true;
    }

    public void off() throws InterruptedException {
        on = false;

        mutex.P();

        for (n = 0; w > 0; w--) {
            wait.V();
        }

        mutex.V();
    }
}