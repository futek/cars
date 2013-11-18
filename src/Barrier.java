public class Barrier {
    private boolean on = false;
    private int numberOfCars;
    private int n = 0;
    private boolean ticket = false;

    public Barrier(int numberOfCars) {
        this.numberOfCars = numberOfCars;
    }

    public synchronized void sync() throws InterruptedException {
        boolean localTicket = ticket;

        if (!on) return;

        n++;

        if (n == numberOfCars) {
            n = 0;
            ticket = !ticket;
            notifyAll();
        } else {
            while (on && localTicket == ticket) {
                wait();
            }
        }
    }

    public synchronized void on() {
        on = true;
    }

    public synchronized void off() {
        on = false;
        n = 0;

        notifyAll();
    }

    public synchronized void shutdown() throws InterruptedException {
        while (n != 0) {
            wait();
        }

        // reentrant synchronization
        // thread will not deadlock itself
        off();
    }
}