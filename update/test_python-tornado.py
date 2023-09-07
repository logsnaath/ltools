import argparse
import tornado.ioloop
import tornado.web

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, Tornado!\n")

def make_app():
    return tornado.web.Application([
        (r"/", MainHandler),
    ])

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Tornado web application")
    parser.add_argument("--port", type=int, default=8888, help="Port number to listen on")
    args = parser.parse_args()

    app = make_app()
    app.listen(args.port)
    print("Server started on port {}".format(args.port))

    tornado.ioloop.IOLoop.current().start()

