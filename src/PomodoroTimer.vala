/**
 *
 */
protected class Pomodoro.Timer : GLib.Object {
  const double WORK_TIME = 25*60;
  const double SHORTBREAK_TIME = 5*60;
  const double LONGBREAK_TIME = 15*60;
  const int SHORT_BREAKS = 4;

  public signal void changed ();

  public bool running {
    get {
      return _running;
    }
    set {
      if (value == _running) {
        return;
      }

      if (timer == null && value) {
        timer = new GLib.Timer ();
        state = State.WORK;
      } else if (value) {
        timer.@continue ();
      } else {
        timer.stop ();
      }

      _running = value;
      update ();
    }
  }

  public double elapsed {
    get {
      return timer != null ? timer.elapsed () : 0;
    }
  }

  public State state {
    get {
      return _state;
    }
    set {
      if (value != State.STOPPED) {
        switch (value) {
          case State.WORK:
            countdown = WORK_TIME;
            break;
          case State.SHORTBREAK:
            countdown = SHORTBREAK_TIME;
            break;
          case State.LONGBREAK:
            countdown = LONGBREAK_TIME;
            break;
        }

        start ();
        update ();
      }

      _state = value;
    }
  }

  public enum State {
    WORK,
    SHORTBREAK,
    LONGBREAK,
    STOPPED
  }

  GLib.Timer timer;
  double countdown = WORK_TIME;
  int breaks;
  State _state;
  bool _running;

  public Timer () {
    debug ("Initiating timer");
  }

  public void update () {
    GLib.Timeout.add_seconds ((uint) (countdown-elapsed+0.333), () => {
      if (!change_state ()) {
        update ();
      }
      return false;
    });
  }

  bool change_state () {
    if (countdown <= elapsed) {
      if (state == State.WORK) {
        state = is_long_break () ? State.LONGBREAK : State.SHORTBREAK;
        breaks++;
      } else {
        state = State.WORK;
      }
      changed ();
      return true;
    }

    return false;
  }

  bool is_long_break () {
    // long pause is one in five
    // 10/5 = 2
    // 8/5 = 1,6
    // print (breaks%SHORTBREAK+1);
    return (breaks%SHORT_BREAKS+1) == 0;
  }

  public void start () {
    if (timer == null) {
      timer = new GLib.Timer ();
    } else {
      timer.start ();
    }
  }

  public void reset () {
    state = State.STOPPED;
    timer = null;
  }

  public void toggle () {
    running = !running;
  }

  public void work () {
    state = State.WORK;
  }

  public void short_break () {
    state = State.SHORTBREAK;
  }

  public void long_break () {
    state = State.LONGBREAK;
  }

  // TODO: display in countdown style
  public string to_string () {
    var min = (int) elapsed / 60;
    var sec = (int) elapsed % 60;

    return "%02d:%02d".printf (min, sec);
  }
}
