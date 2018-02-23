
public class Pomodoro.PopoverWidget : Gtk.Grid {
  private Pomodoro.Timer timer;

  public PopoverWidget (Pomodoro.Indicator indicator, Pomodoro.Timer timer) {
    set_orientation (Gtk.Orientation.VERTICAL);
    margin_top = 6;

    var toggle = new Wingpanel.Widgets.Button (_("Play/Pause"));
    var stop = new Wingpanel.Widgets.Button (_("Stop"));

    // TODO: Use radiobuttons
    var work = new Wingpanel.Widgets.Button (_("Work"));
    var short_break = new Wingpanel.Widgets.Button (_("Short break"));
    var long_break = new Wingpanel.Widgets.Button (_("Long break"));

    toggle.clicked.connect (() => {
      timer.toggle ();
      indicator.close ();
    });

    stop.clicked.connect (() => {
      timer.reset ();
      indicator.close ();
    });

    // TODO: add work state

    short_break.clicked.connect (() => {
      timer.short_break ();
      indicator.close ();
    });

    long_break.clicked.connect (() => {
      timer.long_break ();
      indicator.close ();
    });

    add (toggle);
    add (stop);
    add (new Wingpanel.Widgets.Separator ());
    add (work);
    add (short_break);
    add (long_break);
  }
}
