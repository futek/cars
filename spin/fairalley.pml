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
  :: n > 0 && goesDown != down || goesDown && wb > 0 || !goesDown && wt > 0 ->
     m_wait();
     if
     :: n == 0 && down != goesDown -> break
     :: else -> skip
     fi
  :: else -> break;
  od;

  if
  :: goesDown -> wt--
  :: else -> wb--
  fi;

  n++;
  down = goesDown;

  m_exit()
}

inline leave() {
  m_enter();

  n--;
  if
  :: n == 0 -> m_notifyAll()
  :: else -> skip
  fi;

  m_exit()
}

int goingDown = 0;
int goingUp = 0;

proctype Car(bool goesDown) {
  enter();

  /* record state */
  if
  :: goesDown -> goingDown++; goingDown--
  :: else -> goingUp++; goingUp--
  fi;

  leave();
}

#define I (goingDown == 0 || goingUp == 0)
active proctype Check() {
  atomic { !I -> assert(I) }
}

init {
  int i;
  for (i : 1 .. 2) {
    run Car(true);
    run Car(false)
  }
}