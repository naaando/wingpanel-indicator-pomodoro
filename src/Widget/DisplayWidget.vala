
public class Pomodoro.DisplayWidget : Gtk.Stack {
	private Timer timer;
	private Gtk.Label timer_label;
	private Gtk.Image icon;
	private Cancellable cancellable;

	public DisplayWidget (Timer _timer) {
		timer = _timer;
		timer_label = new Gtk.Label ("00:00");
		icon = new Gtk.Image.from_icon_name ("alarm-symbolic", Gtk.IconSize.MENU);

		add_named (icon, "icon");
		add_named (timer_label, "label");

		button_press_event.connect (on_button_press);
		timer.notify.connect (update);
	}

	private void update () {
		cancellable = cancellable ?? new Cancellable ();

		if (timer.state == Pomodoro.Timer.State.STOPPED) {
			visible_child = icon;
			cancellable.cancel ();
			return;
		}

		update_label_style (timer.state);

		Idle.add (() => {
			if (cancellable.is_cancelled ()) {
				cancellable.reset ();
				return false;
			}

			timer_label.label = timer.to_string ();
			return true;
		});

		visible_child = timer_label;
	}

	private void update_label_style (Timer.State state) {
		//  Fix: style not working
		var style = timer_label.get_style_context ();
		if (state == Timer.State.WORK) {
			style.remove_class ("error");
		} else if (state == Timer.State.SHORTBREAK || state == Timer.State.LONGBREAK) {
			style.add_class ("error");
		}
	}

	private bool on_button_press (Gtk.Widget widget, Gdk.EventButton e) {
		if (e.button == Gdk.BUTTON_MIDDLE) {
			timer.toggle ();
			return Gdk.EVENT_STOP;
		}
		return Gdk.EVENT_PROPAGATE;
	}
}