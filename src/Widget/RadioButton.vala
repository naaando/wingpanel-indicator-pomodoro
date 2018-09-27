
public class Pomodoro.RadioButton : Gtk.ListBoxRow {
	public Gtk.RadioButton radio_button {get;set;}
	public bool active {
		get {
			return radio_button.active;
		}
		set {
			radio_button.active = value;
		}
	}

	public RadioButton(GLib.SList<Gtk.RadioButton>? group,string label) {
		radio_button = new Gtk.RadioButton.with_label (group, label);
		add (radio_button);

		get_style_context ().add_class ("menuitem");
		radio_button.clicked.connect (()=>activate());
	}

	public unowned SList<Gtk.RadioButton> get_group () {
		return radio_button.get_group ();
	}
}
