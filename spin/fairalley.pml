#include "monitor.pml"

/* synchronization variables */
int n = 0;      /* number of cars in alley */
int wt = 0;     /* number of cars waiting at top */
int wb = 0;     /* number of cars waiting at bottom */
bool down = 1;  /* last observed travel direction */

inline enter(goesDown) {
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

/* auxiliary variables */
int goingDown = 0;
int goingUp = 0;

active [4] proctype CarGoingDown() {
  do
  :: skip;

a:   enter(true);

     /* record state */
     goingDown++;
     goingDown--;

b:   leave()
  od
}

active [4] proctype CarGoingUp() {
  do
  :: skip;

a:   enter(false);

     /* record state */
     goingUp++;
     goingUp--;

b:   leave()
  od
}

#define I (goingDown == 0 || goingUp == 0)
active proctype Check() {
  atomic { !I -> assert(I) }
}

/* ltl fairness1 { [] (CarGoingDown[0]@a -> <> CarGoingDown[0]@b) } */
/* ltl fairness2 { [] (CarGoingUp[4]@a -> <> CarGoingUp[4]@b) } */