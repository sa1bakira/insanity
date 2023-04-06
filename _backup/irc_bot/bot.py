#!/usr/bin/env python3

# - open the socket
# - connect to server
# - start listeing
# - wait for server banner
# - join channels
# - wait for commands
# - check ownership
# - parse commands
# - send response

# irc.libera.chat 6667

# -*- coding: utf-8 -*-

import socket
import os

# creating the socket
#/
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)


# config
#/
HOST     = 'irc.libera.chat'
PORT     =  6667
NICK     = 'orwellbot'
USERNAME = ''
REALNAME = '1984'


print('socket created |', s)
remote_ip = socket.gethostbyname(HOST)

print('ip of irc server is:', remote_ip)

s.connect((HOST, PORT))

print('connected to: ', HOST, PORT)

nick_cr = ('NICK ' + NICK + '\r\n').encode()
s.send(nick_cr)

usernam_cr = ('USER botorwell botorwell botorwell :mothinari \r\n').encode()
s.send(usernam_cr)


# channels
#/
s.send('JOIN #testiclenow \r\n'.encode()) 
#s.send('JOIN #blastwave \r\n'.encode()) 



# commands list
#/
commands = ['help','hi','ta','td','tl','hacker','weather']


# owner
#/
owner = ['panku']


# trust users
#/
trust = []



# listening
#/
while 1:
    # buffer
    #/
    data = s.recv(4094).decode('utf-8')
  
    print(data)

    # PONG reply to irc server
    #/
    if data.find('PING') != -1:
        s.send(str('PONG ' + data.split(':')[1] + '\r\n').encode())
        print('PONG sent \n')
    
    # we look for the trigger
    #/
    if data.find('$') != -1:

        # if we find the trigger as first character
        #/
        if data.split(":")[2][0] == "$":

            # we make sure the command is at least 1 character long
            #/
            if len(data.split()[3][2:]) > 1:
            
                # parse data
                #/
                cmd = data.split()[3][2:]
                sender = data.split('!')[0][1:]
                back = str("PRIVMSG " + data.split()[2] + " :")
                to = str(data.split('!')[0][1:] + ": ")
                    

                # commands for everyone
                #/
                if cmd == 'ping':
                    s.send(str(back + "pong" + "\n").encode())

                if cmd == 'help':
                    s.send(str(back + "commands: " + " ".join(commands) + "\n").encode())
                
                if cmd == 'hi':
                    s.send(str(back + to + "Hi!" + "\n").encode())

                if cmd == 'booze':
                   s.send(str(back + "it's beer time!" + "\n").encode())


                # trust + owner commands
                #/
                if cmd == 'hacker':
                    if sender in trust or owner:
                        s.send(str(back + "hackerino!" + "\n").encode())
                    else:
                        s.send(str(back + to + "Not a trusted user." + "\n").encode())

                
                # weather
                #/
                if cmd == 'weather':
                    if sender in trust or owner:
                        if len(data.split()) > 4:
                            city = "+".join(data.split()[4:])
                                
                            wttr = os.popen('curl -s --connect-timeout 1 --max-time 1 wttr.in/' + city).read()

                            if 'We were unable to find your location' in wttr:
                                s.send(str(back + 'can\'t find location!' + "\n").encode())
                            else:
                                wttr = os.popen('curl -s --connect-timeout 1 --max-time 1 wttr.in/' + city + '?format=2').read()
                                s.send(str(back + city.replace('+',' ') + ': ' + wttr + "\n").encode())
                        else:
                            s.send(str(back + 'Need a city.' + "\n").encode())
                    else:
                        s.send(str(back + to + "Not a trusted user." + "\n").encode())


                # owner commands
                #/
                if cmd == 'tl':
                    if sender in owner:
                        s.send(str(back + "Trust users: " + " ".join(trust) + "\n").encode())
                    else:
                        s.send(str(back + to + "Not my master u.u" + "\n").encode())


                if cmd == 'ta':
                    if sender in owner:
                        if len(data.split()) > 4:
                            adduser = data.split()[4]
                            if adduser not in trust:
                                trust.append(adduser)
                                s.send(str(back + to + adduser + " was added." + "\n").encode())
                            else:
                                s.send(str(back + to + adduser + " already in trust list." + "\n").encode())
                        else:
                            s.send(str(back + to + "give me a name to add." + "\n").encode())
                    else:
                        s.send(str(back + to + "Not my master u.u" + "\n").encode())
                

                if cmd == 'td':
                    if sender in owner:
                        if len(data.split()) > 4:
                        
                            deltrust = data.split()[4]
                        
                            if deltrust in trust:
                                trust.remove(deltrust)
                                s.send(str(back + to + deltrust + " was removed." + "\n").encode())
                            else:
                                s.send(str(back + to + deltrust + " is not a trust user." + "\n").encode())
                        else:
                            s.send(str(back + to + "give me a name to remove." + "\n").encode())
                    else:
                        s.send(str(back + to + "Not my master u.u" + "\n").encode())

s.close()


