
public class Pomodoro.Indicator : Wingpanel.Indicator {
	const string APPNAME = "wingpanel-indicator-pomodoro";
	private PopoverWidget popover_widget;
	private DisplayWidget display_widget;
	private Timer pomodoro;
	private Notifier notifier;

	public Indicator (Wingpanel.IndicatorManager.ServerType server_type) {
		Object (code_name: APPNAME,
		display_name: _("Pomodoro"),
		description: _("The Pomodoro timer"));
		visible = true;

		pomodoro = new Timer ();
		notifier = new Notifier (APPNAME);
		pomodoro.changed.connect (show_notification);
	}

	private void show_notification () {
		switch (pomodoro.state) {
			case Timer.State.WORK:
				notifier.show_notification ("Get back to the work",
											"Disable notification, close social networks and focus on what you need to do",
											"alarm-symbolic");
				break;
			case Timer.State.SHORTBREAK:
				notifier.show_notification ("Take a short break",
											"Grab a coffee, drink water or go to bathroom",
											"alarm-symbolic");
				break;
			case Timer.State.LONGBREAK:
				notifier.show_notification ("Take a long break",
											"Have a sunbath, relax or eat some fruits",
											"alarm-symbolic");
				break;
		}
	}

	public override Gtk.Widget get_display_widget () {
		return display_widget = display_widget ?? new DisplayWidget (pomodoro);
	}

	public override Gtk.Widget? get_widget () {
		return popover_widget = popover_widget ?? new PopoverWidget (this, pomodoro);
	}

	public override void opened () {}
	public override void closed () {}
}

public Wingpanel.Indicator? get_indicator (Module module, Wingpanel.IndicatorManager.ServerType server_type) {
	debug ("Activating Pomodoro Indicator");
	var indicator = new Pomodoro.Indicator (server_type);

	return indicator;
}
