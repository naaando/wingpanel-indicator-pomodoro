
public class Pomodoro.PopoverWidget : Gtk.Grid {
  private Pomodoro.Timer timer;

  public PopoverWidget (Pomodoro.Indicator indicator, Pomodoro.Timer timer) {
    set_orientation (Gtk.Orientation.VERTICAL);
    margin_top = 6;

    var toggle_switch = new NightLight.Widgets.Switch (_("Start"), _("Stop"));
    var reset = new Wingpanel.Widgets.Button (_("Reset"));

    // TODO: Use radiobuttons
    var work = new Wingpanel.Widgets.Button (_("Work"));
    var short_break = new Wingpanel.Widgets.Button (_("Short break"));
    var long_break = new Wingpanel.Widgets.Button (_("Long break"));

    toggle_switch.notify["active"].connect (() => {
      timer.running = toggle_switch.active;
    });

    reset.clicked.connect (() => {
      timer.reset ();
      indicator.close ();
      toggle_switch.active = false;
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

    add (toggle_switch);
    add (reset);
    add (new Wingpanel.Widgets.Separator ());
    add (work);
    add (short_break);
    add (long_break);
  }
}
