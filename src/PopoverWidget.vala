
public class Pomodoro.PopoverWidget : Gtk.Grid {
  Pomodoro.Timer timer;
  Pomodoro.Indicator indicator;

  public PopoverWidget (Pomodoro.Indicator _indicator, Pomodoro.Timer _timer) {
    set_orientation (Gtk.Orientation.VERTICAL);
    margin_top = 6;

    timer = _timer;
    indicator = _indicator;

    var toggle_switch = new NightLight.Widgets.Switch (_("Start"), _("Stop"));
    var reset = new Wingpanel.Widgets.Button (_("Reset"));

    toggle_switch.notify["active"].connect (() => {
      timer.running = toggle_switch.active;
    });

    timer.notify.connect (() => {
      toggle_switch.active = timer.running;
    });

    reset.clicked.connect (() => {
      timer.reset ();
      indicator.close ();
      toggle_switch.active = false;
    });

    add (toggle_switch);
    add (reset);
    add (new Wingpanel.Widgets.Separator ());
    add (build_states_box());
  }

  Gtk.ListBox build_states_box () {
    var list_box = new Gtk.ListBox ();
    list_box.selection_mode = Gtk.SelectionMode.NONE;

    var work = new Pomodoro.RadioButton (null, _("Work"));
    var short_break = new Pomodoro.RadioButton (work.get_group (), _("Short break"));
    var long_break = new Pomodoro.RadioButton (short_break.get_group (), _("Long break"));

    list_box.add (work);
    list_box.add (short_break);
    list_box.add (long_break);

    work.activate.connect (() => {
      timer.work ();
      indicator.close ();
    });

    short_break.activate.connect (() => {
      timer.short_break ();
      indicator.close ();
    });
    //
    long_break.activate.connect (() => {
      timer.long_break ();
      indicator.close ();
    });

    timer.notify.connect (()=> {
      switch (timer.state) {
        case Timer.State.WORK:
          work.active = true;
          break;
        case Timer.State.SHORTBREAK:
          short_break.active = true;
          break;
        case Timer.State.LONGBREAK:
          long_break.active = true;
          break;
        default:
          work.active = true;
          break;
      }
    });

    return list_box;
  }
}
