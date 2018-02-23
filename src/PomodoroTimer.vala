/**
 *
 */
protected class Pomodoro.Timer : GLib.Object {
  const double WORK_TIME = 25*60;
  const double SHORTBREAK_TIME = 5*60;
  const double LONGBREAK_TIME = 15*60;

  GLib.Timer timer;
  double countdown = WORK_TIME;
  int short_breaks = 4;
  int breaks;
  State _state;
  bool _running;

  State state {
    get {
      return _state;
    }
    set {
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
      _state = value;

      start ();
      update ();
    }
  }

  public bool running {
    get {
      return _running;
    }
    set {
      if (timer == null && value) {
        timer = new GLib.Timer ();
      }

      if (value) {
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

  enum State {
    WORK,
    SHORTBREAK,
    LONGBREAK
  }

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
      return true;
    }

    return false;
  }

  bool is_long_break () {
    var lb = short_breaks+1;
    return (breaks%lb)==0;
  }

  public void start () {
    if (timer == null) {
      timer = new GLib.Timer ();
    } else {
      timer.start ();
    }
  }

  public void reset () {
    countdown = WORK_TIME;
    timer = null;
  }

  public void toggle () {
    running = !running;
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
