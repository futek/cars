public class Barrier {
    private boolean on = false;
    private int numberOfCars;
    private int n = 0;
    private boolean ticket = false;

    public Barrier(int numberOfCars) {
        this.numberOfCars = numberOfCars;
    }

    public synchronized void sync() {
        boolean localTicket = ticket;

        if (!on) return;

        n++;

        if (n == numberOfCars) {
            n = 0;
            ticket = !ticket;
            notifyAll();
        } else {
            while (localTicket == ticket) {
                try { wait(); } catch (InterruptedException e) {}
            }
        }
    }

    public synchronized void on() {
        on = true;
    }

    public synchronized void off() {
        on = false;

        notifyAll();
    }

    public synchronized void shutdown() {
        while (n != 0) {
            try { wait(); } catch (InterruptedException e) {}
        }

        off();
    }
}