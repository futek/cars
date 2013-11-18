#include "semaphore.pml"

/* synchronization variables */
sem mutex = 1;
sem wait_ = 0;
int n = 0;
int w = 0;
bool down = true;

inline enter(goesDown) {
  int t1;

  do
  :: p(mutex);
     if
     :: n == 0 || goesDown == down -> break
     :: else -> skip
     fi;
     t1 = w; t1++; w = t1;
     v(mutex);
     p(wait_)
  od;
  t1 = n; t1++; n = t1;
  down = goesDown;
  v(mutex)
}

inline leave(goesDown) {
  int t2;

  p(mutex);
  t2 = n; t2--; n = t2;
  if
  :: n == 0 ->
     do
     :: w > 0 ->
        t2 = w; t2--; w = t2;
        v(wait_)
     :: else -> break;
     od
  :: else -> skip
  fi;
  v(mutex)
}

/* auxiliary variables */
int goingDown = 0;
int goingUp = 0;

active [2] proctype CarGoingDown() {
  do
  :: enter(true);

     /* record state */
     goingDown++;
     goingDown--;

     leave(true)
  od
}

active [2] proctype CarGoingUp() {
  do
  :: enter(false);

     /* record state */
     goingUp++;
     goingUp--;

     leave(false)
  od
}

#define I (goingDown == 0 || goingUp == 0)
active proctype Check() {
  atomic { !I -> assert(I) }
}

/* ltl progress { []<>( goingDown > 0 || goingUp > 0 ) } */