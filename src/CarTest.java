//Prototype implementation of Car Test class
//Mandatory assignment
//Course 02158 Concurrent Programming, DTU, Fall 2013

//Hans Henrik Løvengreen     Oct 6, 2013

public class CarTest extends Thread {

    CarTestingI cars;
    int testno;

    public CarTest(CarTestingI ct, int no) {
        cars = ct;
        testno = no;
    }

    public void run() {
        try {
            switch (testno) { 
            case 0:
                // Demonstration of startAll/stopAll.
                // Should let the cars go one round (unless very fast)
                cars.startAll();
                sleep(3000);
                cars.stopAll();
                break;
            
            case 1:
                // Demonstration of removing and adding back cars.
            	// 
                cars.startAll();
                sleep(2000);
                cars.removeCar(1);
                cars.removeCar(2);
                cars.removeCar(3);
                sleep(1000);
                cars.removeCar(4);
                sleep(500);
                cars.removeCar(5);
                cars.restoreCar(5);
                sleep(200);
                cars.restoreCar(4);
                sleep(100);
                cars.restoreCar(3);
                cars.restoreCar(2);
                cars.restoreCar(1);
                cars.restoreCar(1);
                cars.removeCar(1);
                cars.removeCar(1);
                cars.restoreCar(1);
                sleep(1);
                cars.restoreCar(1);
                cars.restoreCar(1);
                sleep(2000);
                cars.stopAll();
                break;
                
            case 2:
                // Demonstration of barrier synchronization.
                // Should let the cars go one round (unless very fast)
            	cars.barrierOn();
            	sleep(1);
                cars.startAll();
                sleep(3000);
                cars.barrierShutDown();
                sleep(3000);
                cars.stopAll();
                break;
                
            case 3:
                // Demonstration of startAll/stopAll.
                // Should let the cars go one round (unless very fast)
                cars.startAll();
                sleep(3000);
                cars.stopAll();
                break;
            
            case 4:
            	// Demonstration of starvation.
            	cars.startAll();
            	cars.setSlow(true);
            	break;
            	
            case 5:
            	// Demonstration of not removing the first car in line.
            	cars.startCar(1);
            	sleep(100);
            	cars.setSlow(true);
            	sleep(500);
            	cars.startCar(5);
            	sleep(1500);
            	cars.startAll();
            	sleep(4000);
            	cars.println("trying to remove car 5");
            	cars.removeCar(5);
            	break;
            	

            case 19:
                // Demonstration of speed setting.
                // Change speed to double of default values
                cars.println("Doubling speeds");
                for (int i = 1; i < 9; i++) {
                    cars.setSpeed(i,50);
                };
                break;

            default:
                cars.println("Test " + testno + " not available");
            }

            cars.println("Test ended");

        } catch (Exception e) {
            System.err.println("Exception in test: "+e);
        }
    }

}



