
public class Pomodoro.Indicator : Wingpanel.Indicator {
    private Pomodoro.PopoverWidget popover_widget;
    private Pomodoro.Timer pomodoro;

    public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (code_name: "wingpanel-indicator-pomodoro",
                display_name: _("Pomodoro"),
                description: _("The Pomodoro timer"));

      pomodoro = new Timer ();
      visible = true;
    }

    public override Gtk.Widget get_display_widget () {
      var spinner = new Gtk.Stack ();
      var indicator_icon = new Gtk.Image.from_icon_name ("alarm-symbolic", Gtk.IconSize.MENU);
      var tlabel = new Gtk.Label ("00:00");

      spinner.add_named (indicator_icon, "icon");
      spinner.add_named (tlabel, "label");

      spinner.button_press_event.connect ((e) => {
        if (e.button == Gdk.BUTTON_MIDDLE) {
          pomodoro.running = !pomodoro.running;
          return Gdk.EVENT_STOP;
        }
        return Gdk.EVENT_PROPAGATE;
      });

      GLib.Timeout.add_seconds (1, () => {
        tlabel.label = pomodoro.to_string ();
        return true;
      });

      pomodoro.notify.connect (() => {
        if (pomodoro.state == Timer.State.STOPPED) {
          spinner.visible_child = indicator_icon;
        } else {
          spinner.visible_child = tlabel;
        }
      });

      return spinner;
    }

    public override Gtk.Widget? get_widget () {
      if (popover_widget == null) {
        popover_widget = new Pomodoro.PopoverWidget (this, pomodoro);
      }

      return popover_widget;
    }

    public void connections () {}

    public override void opened () {}

    public override void closed () {}

}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
    debug ("Activating Pomodoro Indicator");
    var indicator = new Pomodoro.Indicator (server_type);

    return indicator;
}
