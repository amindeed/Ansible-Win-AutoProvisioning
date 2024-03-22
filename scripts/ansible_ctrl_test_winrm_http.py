#!/usr/bin/env python3
import winrm

SERVER_IP = "192.168.56.12"         # Replace with your VM's IP
USERNAME = "Administrator"          # or SERVER\\username
PASSWORD = "aminetest"              # Replace with your password
PORT = 5985

session = winrm.Session(
    target=f"http://{SERVER_IP}:{PORT}/wsman",
    auth=(USERNAME, PASSWORD),
    transport="ntlm",
    read_timeout_sec=10,           # Command execution timeout
    operation_timeout_sec=5       # WSMan operation timeout
)

result = session.run_cmd("whoami")

print("STDOUT:")
print(result.std_out.decode())

print("STDERR:")
print(result.std_err.decode())

print("STATUS CODE:", result.status_code)
