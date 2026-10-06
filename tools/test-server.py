#!/usr/bin/env python3
"""Inert loopback HTTP fixtures. Never accepts payment or real credentials."""
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
import json
import time

class Handler(BaseHTTPRequestHandler):
    redirected = 0
    def log_message(self, *args):
        pass
    def do_GET(self):
        if self.path == '/slow':
            time.sleep(1)
        if self.path == '/redirect':
            self.send_response(302)
            self.send_header('Location', 'http://127.0.0.1:18565/redirect-target')
            self.end_headers()
            return
        if self.path == '/redirect-target':
            Handler.redirected += 1
        body = json.dumps({'cookie': self.headers.get('Cookie'), 'authorization': self.headers.get('Authorization'), 'count': Handler.redirected}).encode()
        if self.path in ('/large', '/stream'):
            body = b'x' * 8192
        if self.path == '/malformed':
            body = b'{broken'
        if self.path == '/html':
            body = b'<html>not API</html>'
        self.send_response(200)
        self.send_header('Content-Type', 'text/html' if self.path == '/html' else 'application/json')
        if self.path != '/stream':
            self.send_header('Content-Length', str(len(body)))
        if self.path == '/cookie':
            self.send_header('Set-Cookie', 'secret=synthetic; Path=/')
        self.end_headers()
        try:
            self.wfile.write(body)
        except (BrokenPipeError, ConnectionResetError):
            pass

ThreadingHTTPServer(('127.0.0.1', 18565), Handler).serve_forever()
