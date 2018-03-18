
public class Pomodoro.Indicator : Wingpanel.Indicator {
    const string APPNAME = "wingpanel-indicator-pomodoro";
    private Pomodoro.PopoverWidget popover_widget;
    private Pomodoro.Timer pomodoro;

    public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (code_name: APPNAME,
                display_name: _("Pomodoro"),
                description: _("The Pomodoro timer"));

      Notify.init (APPNAME);
      pomodoro = new Timer ();

      var notification = new Notify.Notification ("indicator-pomodoro", "", "");
      notification.set_hint ("x-canonical-append", new Variant.string ("allowed"));
      notification.set_urgency (Notify.Urgency.CRITICAL);

      pomodoro.changed.connect (() => {
        switch (pomodoro.state) {
          case Timer.State.WORK:
            notification = new Notify.Notification ("Get back to the work", "Disable notification, close social networks and focus on what you need to do", "alarm-symbolic");
            break;
          case Timer.State.SHORTBREAK:
            notification = new Notify.Notification ("Take a short break", "Grab a coffee, drink water or go to bathroom", "alarm-symbolic");
            break;
          case Timer.State.LONGBREAK:
            notification = new Notify.Notification ("Take a long break", "Have a sunbath, relax or eat some fruits", "alarm-symbolic");
            break;
          default:
            notification = new Notify.Notification ("Unknown state", "", null);
            break;
        }

        notification.app_name = APPNAME;
        try {
            notification.show ();
        } catch (Error e) {
            warning (e.message);
        }
      });

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
        var style = tlabel.get_style_context ();
        switch (pomodoro.state) {
          case Timer.State.WORK:
            style.remove_class ("error");
            break;
          case Timer.State.SHORTBREAK:
          case Timer.State.LONGBREAK:
            style.add_class ("error");
            break;
        }

        if (pomodoro.state == Pomodoro.Timer.State.STOPPED) {
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
