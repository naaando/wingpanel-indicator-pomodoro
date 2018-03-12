
public class Pomodoro.Indicator : Wingpanel.Indicator {
    const string APPNAME = "wingpanel-indicator-pomodoro";
    private Pomodoro.PopoverWidget popover_widget;
    private Pomodoro.Timer pomodoro;

    public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
        Object (code_name: APPNAME,
                display_name: _("Pomodoro"),
                description: _("The Pomodoro timer"));

      pomodoro = new Timer ();

      pomodoro.changed.connect (() => {
        switch (pomodoro.state) {
          Notify.Notification notification;
          case Timer.State.WORK:
            notification = new Notify.Notification ("Volte ao trabalho", "Desative as notificações, feche as redes sociais e se concentre no que veio fazer", null);
            break;
          case Timer.State.SHORTBREAK:
            notification = new Notify.Notification ("Tire uma pequena pausa", "Pegue um café, beba uma agua ou vá ao banheiro", null);
            break;
          case Timer.State.LONGBREAK:
            notification = new Notify.Notification ("Tire uma longa pausa", "Vá tomar um sol, relaxar ou comer uma fruta", null);
            break;
        }

        notification.app_name = APPNAME;
        notification.show ();
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
