#include "monitor.pml"

int n = 0;      /* number of cars in alley */
int wt = 0;     /* number of cars waiting at top */
int wb = 0;     /* number of cars waiting at bottom */
bool down = 1;  /* last observed travel direction */

inline enter() {
  m_enter();

  if
  :: goesDown -> wt++
  :: else -> wb++
  fi;

  do
  :: n == 0 && down != goesDown || (n == 0 || goesDown == down) && (goesDown && wb == 0 || !goesDown && wt == 0) -> break
  :: else -> m_wait()
  od;

  if
  :: goesDown -> wt--
  :: else -> wb--
  fi;

  n++;
  down = goesDown;

  m_leave()
}

inline leave() {
  m_enter();

  n--;
  if
  :: n == 0 -> m_notifyAll()
  :: else -> skip
  fi;

  m_leave()
}

int goingDown = 0;
int goingUp = 0;

proctype Car(bool goesDown) {
  do
  :: skip;

     a: enter();

     /* record state */
     if
     :: goesDown -> goingDown++; goingDown--
     :: else -> goingUp++; goingUp--
     fi;

     b: leave()
  od
}

#define I (goingDown == 0 || goingUp == 0)
active proctype Check() {
  atomic { !I -> assert(I) }
}

init {
  int i;
  for (i : 1 .. 4) {
    run Car(true);
    run Car(false)
  }
}

/* ltl fairness { [] (Car[2]@a -> <> Car[2]@b)
               && [] (Car[3]@a -> <> Car[3]@b)
               && [] (Car[4]@a -> <> Car[4]@b)
               && [] (Car[5]@a -> <> Car[5]@b)
               && [] (Car[6]@a -> <> Car[6]@b)
               && [] (Car[7]@a -> <> Car[7]@b)
               && [] (Car[8]@a -> <> Car[8]@b)
               && [] (Car[9]@a -> <> Car[9]@b) } */