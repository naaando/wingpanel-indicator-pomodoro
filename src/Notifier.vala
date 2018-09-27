
public class Pomodoro.Notifier : Object {
	string app_name;

	public Notifier (string _app_name) {
		app_name = _app_name;
		Notify.init (app_name);
	}

	public void show_notification (string title, string description, string icon_path) {
	  var notification = new Notify.Notification (title, description, icon_path);
		notification.app_name = app_name;
		notification.set_hint ("x-canonical-append", new Variant.string ("allowed"));
		notification.set_urgency (Notify.Urgency.CRITICAL);

		try {
			notification.show ();
		} catch (Error e) {
			warning (e.message);
		}
	}
}