#define sem int

inline p(s) {
  atomic { s > 0 -> s-- }
}

inline v(s) {
  s++
}

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

  do
  :: /* enter */
     do
     ::
        p(mutex);
        if :: (n == 0 || goesDown == down) -> break :: else -> skip fi;
        /* t = w; t++; w = t; */ w++;
        v(mutex);
        if :: goesDown -> p(top) :: else -> p(bot) fi
     od;
     /* t = n; t++; n = t; */ n++;
     if :: (n == 1) -> down = goesDown :: else -> skip fi;
     v(mutex);

     /* record state */
     if
     :: goesDown -> goingDown++; goingDown--
     :: else -> goingUp++; goingUp--
     fi;

     /* leave */
     p(mutex);
     /* t = n; t--; n = t; */ n--;
     if
     :: (n == 0) ->
        sem s;
        if :: goesDown -> s = bot :: else -> s = top fi;
        do
        :: if :: !(w > 0) -> break :: else -> skip fi;
           /* t = w; t--; w = t; */ w--;
           v(s)
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
  for (no : 1 .. 2) {
    run Car(true);
    run Car(false)
  }
}