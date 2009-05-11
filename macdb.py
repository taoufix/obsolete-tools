#!/usr/bin/python
# By:
#     Taoufik El Aoumari aka taoufix
#     Samir Khemiri

import os, sqlite3, sys


def add_machine(conn, mac, ip, name):
    cur = conn.cursor()
    try:
        cur.execute('insert into machines values(?, ?, ?)', (mac, ip, name))
    except sqlite3.IntegrityError:
        cur.execute('update machines set ip=? where mac=?', (ip, mac))
    finally:
        conn.commit()
        cur.close()

def print_ips(conn, mac):
    cur = conn.cursor()
    cur.execute('select ip, name from machines where mac=?', (mac,))
    print('IP        \tNAME')
    for row in cur:
        print('%s\t%s' %(row))
        
    cur.execute('select ip from history where mac=?', (mac,))
    print('---')
    for row in cur:
        print('%s' %(row))
    conn.commit()
    cur.close()

# main

argc = len(sys.argv) - 1 

if argc == 0 or argc > 3:
    print('Usage: '+sys.argv[0]+' MAC [IP [HOST_NAME]]')
    sys.exit(1)

db_path = os.getenv('HOME')+'.macdb'+os.sep+'machines.db'
conn = sqlite3.connect(db_path)

if argc ==  1:
    print_ips(conn, sys.argv[1].lower())
else:
    mac, ip = sys.argv[1:3]
    if argc == 3:
        name = sys.argv[3]
    else:
        name = 'unknown'
    add_machine(conn, mac.lower(), ip, name.lower())

# Database schema
"""
create table machines (
       mac	text not null primary key,
       ip    	text,
       name	text
);

create table history (
       mac	text not null,
       ip	text
);

-- history.mac foreign key -> machines.mac
create trigger history_mac_delete_cascade
after delete on machines
for each row
begin
	delete from history where mac = old.mac;
end;

-- log history
create trigger history_update
after update on machines
for each row
when (select 1 from history where mac = old.mac and ip = old.ip) is null
begin
	insert into history values(old.mac, old.ip);
end;
"""

