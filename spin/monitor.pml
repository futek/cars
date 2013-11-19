#include "semaphore.pml"

sem m_lock = 1;  /* mutual exclusion semaphore */
sem m_cond = 0;  /* condition semaphore */
sem m_next = 0;  /* next semaphore */
int m_count = 0; /* number of waiting processes */

inline m_enter() {
  p(m_lock)
}

inline m_leave() {
  v(m_lock)
}

inline m_wait() {
  atomic {
    m_count++;
    v(m_lock);
    p(m_cond);
    v(m_next);
    p(m_lock)
  }
}

inline m_notify() {
  atomic {
    if
    :: m_count == 0 -> skip
    :: else -> v(m_cond); p(m_next); m_count--
    fi
  }
}

inline m_notifyAll() {
  atomic {
    do
    :: m_count == 0 -> break
    :: else -> v(m_cond); p(m_next); m_count--
    od
  }
}

/*
active proctype m_spuriousWakeup() {
  m_notifyAll()
}
*/