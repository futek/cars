#include "semaphore.pml"

/* auxiliary variables */
int round1 = 0;
int round2 = 0;

/* const equal to numberOfCars - 2 */
#define NUMBER_OF_CARS_MINUS_2 2

/* synchronization variables */
bool on = true;
int numberOfCars = 4; /* must be >= 2 */
sem mutex = 1;
sem wait_ = 0;
sem next = 0;
int n = 0;

inline sync() {
  int t;

  if
  :: !on -> skip
  :: else ->
     p(mutex);
     t = n; t++; n = t;
     if
     :: n == numberOfCars ->
        do
        :: n > 1 ->
           v(wait_);
           p(next);
           t = n; t--; n = t
        :: else -> break
        od;
        n = 0;
        v(mutex)
     :: else ->
        v(mutex);
        p(wait_);
        v(next)
     fi
  fi
}

active proctype Car1() {
  do
  :: skip;

a:   sync();

     /* record state */
b:   round1 = (round1 + 1) % 4
  od
}

active proctype Car2() {
  do
  :: sync();

     /* record state */
     round2 = (round2 + 1) % 4
  od
}

active [NUMBER_OF_CARS_MINUS_2] proctype Car() {
  do
  :: sync()
  od
}

#define I ((round1 + 2) % 4 != round2 && (round2 + 2) % 4 != round1)
active proctype Check() {
  atomic { !I -> assert(I) }
}

/* ltl liveness { []( Car1@a -> <> Car1@b ) } */