#include "semaphore.pml"

sem m_lock = 1;   /* mutual exclusion semaphore */
sem m_cond = 0;   /* condition semaphore */
int m_count = 0;  /* number of waiting processes */
int m_dummy = 0;  /* dummy variable used in for-loop */

inline m_enter() {
  p(m_lock);
}

inline m_exit() {
  v(m_lock);
}

inline m_wait() {
  m_count++;
  p(m_cond)
}

inline m_notify() {
  m_count--;
  v(m_cond)
}

inline m_notifyAll() {
  m_count = 0;
  for (m_dummy : 1 .. m_count) {
    v(m_cond)
  };
}

/*
active proctype m_spuriousWakeup() {
  m_notifyAll()
}
*/