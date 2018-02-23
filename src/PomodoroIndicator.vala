
public class Pomodoro.Indicator : Wingpanel.Indicator {
    private Pomodoro.PopoverWidget popover_widget;
    private Pomodoro.Timer timer;

    public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (code_name: "wingpanel-indicator-pomodoro",
                display_name: _("Pomodoro"),
                description: _("The Pomodoro timer"));

      timer = new Timer ();
      visible = true;
    }

    public override Gtk.Widget get_display_widget () {
      var tlabel = new Gtk.Label ("00:00");
      GLib.Timeout.add_seconds (1, () => {
        tlabel.label = timer.to_string ();
        return true;
      });

      return tlabel;
    }

    public override Gtk.Widget? get_widget () {
      if (popover_widget == null) {
        popover_widget = new Pomodoro.PopoverWidget (this, timer);
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
