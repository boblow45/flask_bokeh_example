import os
from flask import Flask, render_template, send_from_directory
from tornado.ioloop import IOLoop

from threading import Thread

from bokeh.server.server import Server
from bokeh.embed import server_document

from .bokeh_exm import page

app = Flask(__name__)

PORT = 80

# BK_ADD = "127.0.0.1"
BK_ADD = "10.24.0.3"
BK_PORT = 5006


@app.route("/favicon.ico")
def fav():
    return send_from_directory(os.path.join(app.root_path, "static"), "favicon.ico")


def bkapp(doc):
    pg = page()
    doc.add_root(pg)


@app.route("/", methods=["GET"])
def bkapp_page():
    script = server_document(f"http://{BK_ADD}:{BK_PORT}/bkapp")
    return render_template("index.html", script=script, template="Flask")


def bk_worker():
    server = Server(
        {"/bkapp": bkapp},
        io_loop=IOLoop(),
        allow_websocket_origin=[f"{BK_ADD}:{PORT}"],
    )
    server.start()
    server.io_loop.start()


Thread(target=bk_worker).start()


if __name__ == "__main__":
    ADDRESS = "0.0.0.0"
    # Only for debugging while developing
    app.run(host=ADDRESS, debug=True, port=PORT)
