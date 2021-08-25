class Observer {
  void update() {}
}

class Subject {
  static List<Observer> observers;
  static void attach(Observer o) {}
  static void detach(Observer o) {}
  static void notify() {}
}
