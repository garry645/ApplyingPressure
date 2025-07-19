#!/usr/bin/env python3
"""
Flutter Web Server Manager
Manages Flutter web server for mobile testing with hot reload support
"""

import subprocess
import sys
import os
import time
import signal
import socket
import argparse
from pathlib import Path

class FlutterWebServer:
    def __init__(self, port=8090):
        self.port = port
        self.pid_file = Path(".flutter_server.pid")
        self.log_file = Path("flutter_web.log")
        self.process = None
        
    def get_local_ip(self):
        """Get the local IP address"""
        try:
            # Create a socket to determine local IP
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
            s.close()
            return ip
        except:
            return "localhost"
    
    def is_port_in_use(self, port):
        """Check if a port is already in use"""
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
            return s.connect_ex(('localhost', port)) == 0
    
    def get_pid(self):
        """Get the PID from the PID file"""
        if self.pid_file.exists():
            try:
                return int(self.pid_file.read_text().strip())
            except:
                return None
        return None
    
    def is_running(self):
        """Check if the server is running"""
        pid = self.get_pid()
        if pid:
            try:
                # Check if process exists
                os.kill(pid, 0)
                return True
            except OSError:
                # Process doesn't exist, clean up PID file
                self.pid_file.unlink(missing_ok=True)
                return False
        return False
    
    def start(self):
        """Start the Flutter web server"""
        if self.is_running():
            print(f"✅ Flutter web server is already running")
            print(f"🌐 Access at: http://{self.get_local_ip()}:{self.port}")
            return
        
        # Kill any process using the port
        if self.is_port_in_use(self.port):
            print(f"⚠️  Port {self.port} is in use, attempting to free it...")
            subprocess.run(f"lsof -ti:{self.port} | xargs kill -9", 
                         shell=True, capture_output=True)
            time.sleep(2)
        
        print(f"🚀 Starting Flutter web server on port {self.port}...")
        
        # Start Flutter process completely detached
        with open(self.log_file, 'w') as log:
            self.process = subprocess.Popen(
                ['flutter', 'run', '-d', 'web-server', 
                 '--web-hostname', '0.0.0.0', 
                 '--web-port', str(self.port)],
                stdout=log,
                stderr=subprocess.STDOUT,
                stdin=subprocess.DEVNULL,
                start_new_session=True,
                preexec_fn=os.setpgrp if sys.platform != 'win32' else None
            )
        
        # Save PID
        self.pid_file.write_text(str(self.process.pid))
        
        # Don't wait - just start and return immediately
        print(f"✅ Flutter web server starting in background (PID: {self.process.pid})")
        print(f"🌐 Will be available at: http://{self.get_local_ip()}:{self.port}")
        print(f"📱 Open this URL on your phone once the server is ready")
        print(f"ℹ️  Check status with: python flutter_server.py status")
        print(f"📋 View logs with: python flutter_server.py logs")
    
    def stop(self):
        """Stop the Flutter web server"""
        pid = self.get_pid()
        if pid:
            try:
                print(f"🛑 Stopping Flutter web server (PID: {pid})...")
                os.kill(pid, signal.SIGTERM)
                time.sleep(1)
                # Force kill if still running
                try:
                    os.kill(pid, signal.SIGKILL)
                except:
                    pass
                self.pid_file.unlink(missing_ok=True)
                print("✅ Server stopped")
            except OSError:
                print("⚠️  Server not running (cleaning up)")
                self.pid_file.unlink(missing_ok=True)
        else:
            print("ℹ️  No server running")
    
    def reload(self):
        """Hot reload the application"""
        pid = self.get_pid()
        if pid and self.is_running():
            print("🔄 Triggering hot reload...")
            try:
                # Create a FIFO pipe for communication
                fifo_path = f"/tmp/flutter_reload_{pid}"
                if not os.path.exists(fifo_path):
                    os.mkfifo(fifo_path)
                
                # Send reload signal by killing with SIGUSR1 (a common reload signal)
                # Flutter doesn't support this directly, so we'll use a workaround
                # We'll restart the app with a quick stop/start
                print("ℹ️  Hot reload via restart (Flutter web-server limitation)")
                self.restart()
            except Exception as e:
                print(f"❌ Failed to trigger hot reload: {e}")
        else:
            print("❌ Server not running")
    
    def status(self):
        """Show server status"""
        if self.is_running():
            pid = self.get_pid()
            print(f"✅ Flutter web server is running")
            print(f"   PID: {pid}")
            print(f"   Port: {self.port}")
            
            # Check if server is ready
            if self.log_file.exists():
                content = self.log_file.read_text()
                if "lib/main.dart is being served at" in content:
                    print(f"   Status: Ready ✅")
                    print(f"   Local URL: http://{self.get_local_ip()}:{self.port}")
                    print(f"   📱 Access on phone: http://{self.get_local_ip()}:{self.port}")
                else:
                    print(f"   Status: Starting... ⏳")
                    print(f"   (Server will be at: http://{self.get_local_ip()}:{self.port})")
                
                print("\n📋 Recent logs:")
                logs = content.strip().split('\n')
                for line in logs[-5:]:
                    print(f"   {line}")
        else:
            print("❌ No server running")
    
    def logs(self):
        """Show and follow logs"""
        if not self.log_file.exists():
            print("❌ No log file found")
            return
        
        print(f"📋 Following logs from {self.log_file}...")
        print("   (Press Ctrl+C to stop)")
        
        try:
            # Use tail -f for real-time log following
            subprocess.run(['tail', '-f', str(self.log_file)])
        except KeyboardInterrupt:
            print("\n👋 Stopped following logs")
    
    def restart(self):
        """Restart the server"""
        print("🔄 Restarting Flutter web server...")
        self.stop()
        time.sleep(2)
        self.start()

def main():
    parser = argparse.ArgumentParser(description='Flutter Web Server Manager')
    parser.add_argument('command', 
                       choices=['start', 'stop', 'restart', 'reload', 'status', 'logs'],
                       help='Command to execute')
    parser.add_argument('--port', type=int, default=8090, 
                       help='Port number (default: 8090)')
    
    args = parser.parse_args()
    
    server = FlutterWebServer(port=args.port)
    
    # Execute command
    command_map = {
        'start': server.start,
        'stop': server.stop,
        'restart': server.restart,
        'reload': server.reload,
        'status': server.status,
        'logs': server.logs
    }
    
    command_map[args.command]()

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print("Flutter Web Server Manager")
        print("Usage: python flutter_server.py {start|stop|restart|reload|status|logs}")
        print("")
        print("Commands:")
        print("  start    - Start the Flutter web server")
        print("  stop     - Stop the Flutter web server")
        print("  restart  - Restart the Flutter web server")
        print("  reload   - Hot reload the application")
        print("  status   - Show server status")
        print("  logs     - Show and follow server logs")
        print("")
        print("Options:")
        print("  --port   - Specify port number (default: 8090)")
    else:
        main()