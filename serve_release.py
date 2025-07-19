#!/usr/bin/env python3
"""
Simple web server for serving Flutter release builds
"""

import http.server
import socketserver
import os
import socket

PORT = 8090

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory='build/web', **kwargs)
    
    def end_headers(self):
        # Add CORS headers
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, POST, OPTIONS')
        self.send_header('Access-Control-Allow-Headers', '*')
        # Add proper MIME types
        if self.path.endswith('.js'):
            self.send_header('Content-Type', 'application/javascript')
        elif self.path.endswith('.json'):
            self.send_header('Content-Type', 'application/json')
        super().end_headers()

def get_local_ip():
    """Get the local IP address"""
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(("8.8.8.8", 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except:
        return "localhost"

if __name__ == "__main__":
    Handler = MyHTTPRequestHandler
    
    with socketserver.TCPServer(("0.0.0.0", PORT), Handler) as httpd:
        local_ip = get_local_ip()
        print(f"🚀 Serving Flutter release build at:")
        print(f"   Local: http://localhost:{PORT}")
        print(f"   Network: http://{local_ip}:{PORT}")
        print(f"   📱 Open the Network URL on your phone")
        print(f"\nPress Ctrl+C to stop the server")
        
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n👋 Server stopped")