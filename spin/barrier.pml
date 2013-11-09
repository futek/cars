#define sem int

inline p(s) {
  atomic { s > 0 -> s-- }
}

inline v(s) {
  s++
}

int currentRound = 0;
int carsOntoNextRound = 0;

bool on = true;
int numberOfCars = 9;
sem mutex = 1;
sem wait_ = 0;
sem next = 0;
int n = 0;
int w = 0;

active [numberOfCars] proctype Car() {
  int round = 0;
  int t;

  do
  :: /* sync */
     if
     :: !on -> skip
     :: else ->
        p(mutex);
        t = n; t++; n = t;
        if
        :: n < numberOfCars ->
           t = w; t++; w = t;
           v(mutex);
           p(wait_);
           v(next)
        :: else ->
           n = 0;
           do
           :: w > 0 ->
              v(wait_);
              p(next);
              t = w; t--; w = t
           :: else -> break
           od;
           v(mutex)
        fi
     fi;

     /* check */
     atomic {
       round = (round + 1) % 3;
       if
       :: currentRound == 0 && round == 2
       || currentRound == 1 && round == 0
       || currentRound == 2 && round == 1 ->
          assert(false); /* car is two rounds ahead */
       :: else -> skip;
       fi;
       carsOntoNextRound++;
       if
       :: carsOntoNextRound == numberOfCars ->
          carsOntoNextRound = 0;
          currentRound = (currentRound + 1) % 3
       :: else -> skip
       fi
     }
  od
}