#include "semaphore.pml"

sem m_lock = 1; /* mutual exclusion semaphore */
chan m_cond = [0] of { bool } /* condition rendezvous channel */
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
    m_cond!true;
    p(m_lock)
  }
}

inline m_notify() {
  atomic {
    if
    :: m_count == 0 -> skip
    :: else -> m_cond?true; m_count--
    fi
  }
}

inline m_notifyAll() {
  atomic {
    do
    :: m_count == 0 -> break
    :: else -> m_cond?true; m_count--
    od
  }
}

/*
active proctype m_spuriousWakeup() {
  m_notifyAll()
}
*/