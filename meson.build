project ('pomodoro', ['vala', 'c'],
    version: '1.1.0',
    meson_version: '>=0.34'
)

subdir ('po')

shared_module(
    meson.project_name (),
    'src/Pomodoro/Timer.vala',
    'src/Widget/DisplayWidget.vala',
    'src/Widget/PopoverWidget.vala',
    'src/Widget/RadioButton.vala',
    'src/Widget/RevealerSwitch.vala',
    'src/Indicator.vala',
    'src/Notifier.vala',
    dependencies : [
        dependency('glib-2.0'),
        dependency('gobject-2.0'),
        dependency('gtk+-3.0'),
        dependency('granite'),
        dependency('wingpanel-2.0'),
        dependency('libnotify'),
    ],
    install: true,
    install_dir : '/usr/lib/x86_64-linux-gnu/wingpanel/'
)