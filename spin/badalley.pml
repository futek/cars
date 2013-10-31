#define sem int

inline p(s) {
  atomic { s > 0 -> s-- }
}

inline v(s) {
  s++
}

int goingDown = 0;
int goingUp = 0;

sem top = 0;
sem bot = 0;
int n = 0;

proctype Car(bool goesDown) {
  sem a, b;
  int t;

  do
  :: if
     :: goesDown -> a = top; b = bot
     :: else -> a = bot; b = top
     fi;

     /* enter */
     p(a);
     if
     :: n == 0 -> p(b)
     :: else -> skip
     fi;
     t = n; t++; n = t;
     v(a);

     /* record state */
     if
     :: goesDown -> goingDown++; goingDown--
     :: else -> goingUp++; goingUp--
     fi;

     /* leave */
     p(a);
     t = n; t--; n = t;
     if
     :: n == 0 -> v(b)
     :: else -> skip
     fi;
     v(a)
  od
}

#define I (goingDown == 0 || goingUp == 0)
active proctype Check() {
  !I -> assert(I)
}

init {
  run Car(true);
  run Car(false)
}