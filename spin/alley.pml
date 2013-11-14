#include "semaphore.pml"

int goingDown = 0;
int goingUp = 0;

sem mutex = 1;
sem top = 0;
sem bot = 0;
int n = 0;
int w = 0;
bool down = true;

proctype Car(bool goesDown) {
  int t;
  sem a, b;

  if
  :: goesDown -> a = top; b = bot
  :: else -> a = bot; b = top
  fi;

  do
  :: /* enter */
     do
     :: p(mutex);
        if
        :: n == 0 || goesDown == down -> break
        :: else -> skip
        fi;
        t = w; t++; w = t;
        v(mutex);
        p(a)
     od;
     t = n; t++; n = t;
     down = goesDown;
     v(mutex);

     /* record state */
     if
     :: goesDown -> goingDown++; goingDown--
     :: else -> goingUp++; goingUp--
     fi;

     /* leave */
     p(mutex);
     t = n; t--; n = t;
     if
     :: n == 0 ->
        do
        :: w > 0 ->
           t = w; t--; w = t;
           v(b)
        :: else -> break;
        od
     :: else -> skip
     fi;
     v(mutex);
  od
}

#define I (goingDown == 0 || goingUp == 0)
active proctype Check() {
  !I -> assert(I)
}

init {
  int no;
  for (no : 1 .. 4) {
    run Car(true);
    run Car(false)
  }
}