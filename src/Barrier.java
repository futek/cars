public class Barrier {
    private boolean on = false;
    private int numberOfCars;
    private Semaphore mutex = new Semaphore(1);
    private Semaphore wait = new Semaphore(0);
    private Semaphore next = new Semaphore(0);
    private int n = 0;

    public Barrier(int numberOfCars) {
        this.numberOfCars = numberOfCars;
    }

    public void sync() throws InterruptedException {
        if (!on) return;

        mutex.P();

        n++;

        if (n < numberOfCars) {
            mutex.V();
            wait.P();
            next.V();
            return;
        }

        while (n > 1) {
            wait.V();
            next.P();
            n--;
        }

        n = 0;

        mutex.V();
    }

    public void on() throws InterruptedException {
        mutex.P();

        on = true;

        mutex.V();
    }

    public void off() throws InterruptedException {
        mutex.P();

        on = false;

        while (n > 1) {
            wait.V();
            next.P();
            n--;
        }

        n = 0;

        mutex.V();
    }
}