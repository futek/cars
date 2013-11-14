#define sem int

inline p(s) {
  atomic { s > 0 -> s-- }
}

inline v(s) {
  s++
}