import sqlite3

username = input("Enter username: ")

conn = sqlite3.connect("users.db")
cursor = conn.cursor()

query = "SELECT * FROM users WHERE username = '" + username + "'"

cursor.execute(query)

print(cursor.fetchall())
