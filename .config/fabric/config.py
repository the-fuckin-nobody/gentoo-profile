import fabric
from fabric import Application
from fabric.widgets.datetime import DateTime
from fabric.widgets.centerbox import CenterBox
from fabric.widgets.wayland import WaylandWindow as Window
from fabric.core.service import Signal, Service

class Niri(Service):
    def __init__(self, **kwargs):
        super().__init__()

class StatusBar(Window):
    def __init__(self, **kwargs):
        super().__init__(
            layer="top",
            anchor="left top right",
            exclusivity="auto",
            # **kwargs
        )

        self.date_time = DateTime()
        self.children = CenterBox(center_children=self.date_time)

if __name__ == "__main__":
    bar = StatusBar(layer="overlay")
    app = Application("bar-example", bar)
    app.run()
