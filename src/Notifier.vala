
public class Pomodoro.Notifier : Object {
	Application app;

	public Notifier () {
		try {
			app = new Application ("pomodoro.timer", ApplicationFlags.FLAGS_NONE);
			app.register ();
		} catch (Error e) {
			warning (e.message);
		}
	}

	public void show_notification (string title, string description) {
		//  var icon = new GLib.ThemedIcon ("appointment-soon");

		var notification = new Notification (title);
		notification.set_body (description);
		//  notification.set_icon (icon);

		app.send_notification ("pomodoro.timer", notification);
	}
}