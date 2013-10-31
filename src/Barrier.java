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

    public void sync() {
        if (!on) return;

        while (true) {
            try { mutex.P(); } catch (InterruptedException e) {}
            n++;
            if (n == numberOfCars)
                break;
            w++;
            mutex.V();
            try { wait.P(); } catch (InterruptedException e) {}
            next.V();
            return;
        }

        for (n = 0; w > 0; w--) {
            wait.V();
            try { next.P(); } catch (InterruptedException e) {}
        }

        mutex.V();
    }

    public void on() {
        on = true;
    }

    public void off() {
        on = false;

        try { mutex.P(); } catch (InterruptedException e) {}

        for (n = 0; w > 0; w--) {
            wait.V();
        }

        mutex.V();
    }
}