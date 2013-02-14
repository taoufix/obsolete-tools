#!/usr/bin/env python

import threading, gtk
import sys, zipfile, os, os.path


class FractionSetter(threading.Thread):
    stopthread = threading.Event()

    def run(self):
        global progressbar 
        frac = 0.0
        zfobj = zipfile.ZipFile(file)
        list = zfobj.namelist()
        l = len(list)
        for name in list:
            if name.endswith('/'):
                os.mkdir(os.path.join(dir, name))

        for name in list:
            frac = frac + 1.0/l
            if frac > 1.0:
                frac  = 1.0
            gtk.gdk.threads_enter()
            progressbar.set_fraction(frac)
            gtk.gdk.threads_leave()
            if not name.endswith('/'):
                outfile = open(os.path.join(dir, name), 'wb')
                outfile.write(zfobj.read(name))
                outfile.close()

        main_quit(self)

    def stop(self):
        self.stopthread.set()

def main_quit(obj):
    global fs
    fs.stop()
    gtk.main_quit()


def error(msg):
    window = gtk.Window(gtk.WINDOW_TOPLEVEL)
    window.set_deletable(0)
    w, h = window.get_size()
    window.move((gtk.gdk.screen_width() - w)/2, (gtk.gdk.screen_height() -h)/2)
    window.set_border_width(10)
    window.set_title("Error")
    label = gtk.Label(msg + "   ")
    button = gtk.Button("    OK    ")
    button.connect("clicked", prog_quit, None)
    button.connect_object("clicked", gtk.Widget.destroy, window)
    box1 = gtk.VBox(False, 5)
    box1.pack_start(label, True, True, 0)
    align = gtk.Alignment(0.5, 0.5, 0, 0)
    align.add(button)
    box1.pack_start(align, False, False, 5)
    window.add(box1)
    window.show_all()
    gtk.main()

def prog_quit(a, b):
    sys.exit(1)


if len(sys.argv) != 2:
    error("No file giving")
    sys.exit(1)

file = sys.argv[1]
dir = file + "_dir"

try:
    os.mkdir(dir, 0777)
    gtk.gdk.threads_init()
    window = gtk.Window()
    w, h = window.get_size()
    progressbar = gtk.ProgressBar()
    vbox = gtk.VBox(False, 5)
    vbox.set_border_width(10)
    window.add(vbox)
    label = gtk.Label("Unizping " + file + " to " + dir)
    vbox.pack_start(label, False, True, 0)
    separator = gtk.HSeparator()
    vbox.pack_start(separator, False, False, 0)
    vbox.pack_start(progressbar, False, False, 5)
    window.move((gtk.gdk.screen_width() - w)/2, (gtk.gdk.screen_height() -h)/2)
    window.set_title("Unziping " + file)
    window.show_all()
    window.connect('destroy', main_quit)
    fs = FractionSetter()
    fs.start()
    gtk.main()

except OSError:
    error("Diretory '" + dir + "' exists")
    sys.exit(1)
