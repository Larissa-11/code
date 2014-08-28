#!/usr/bin/env python3

import optparse
import sys
import socket
import struct
import pickle
import Global

Address = Global.Address
VERSION = Global.VERSION
MAX_BLOCK_LEN = Global.MAX_BLOCK_LEN
PICKLE_PROTOCOL = Global.PICKLE_PROTOCOL
SET_STRUCT_PARAM = Global.SET_STRUCT_PARAM
STATUS = Global.STATUS

class SocketManager:
    def __init__(self, address):
        self.address = address
    
    def __enter__(self):
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.connect(self.address)
        return self.sock
    
    def __exit__(self, *ignore):
        self.sock.close()
    

def handle_request(*items, wait_for_reply=True):
    InfoStruct = struct.Struct(SET_STRUCT_PARAM)
    data = pickle.dumps(items,PICKLE_PROTOCOL)
    try:
        with SocketManager(Address) as sock:
            sock.sendall(InfoStruct.pack(len(data), VERSION))
            sock.sendall(data)
            if not wait_for_reply:
                return
            size_data = sock.recv(InfoStruct.size)
            size = InfoStruct.unpack(size_data)[0]
            result = bytearray()
            while True:
                data = sock.recv(MAX_BLOCK_LEN)
                if not data:
                    break
                result.extend(data)
                if len(result) >= size:
                    break
        return pickle.loads(result)
    except socket.error as err:
        print("{0}: is the pyjob_server running?".format(err))
        sys.exit(1)


def main():

    parser = optparse.OptionParser()
    parser.group.add_option('-s','--status',dest='status',type='str',
                      help=("Select the jobs to show by their status. "
                            "[format: status1,status2,...  default: 'all']"))
    parser.group.add_option('-u','--user',dest='user',type='str',
                      help=("Select the jobs to show by their user. "
                            "[format: user1,user2,...  default: 'all']"))
    parser.set_description(description='This command lists the jobs in the '
                           ' queue.')
    
    (opts, _) = parser.parse_args()
    
    ok, Queue = handle_request('STATUS_QUEUE')
    
    if opts.status is not None:
        status = set(opts.status.split(','))
        if not len(status - STATUS.keys()):
            print('Wrong status specification. Possible values are:\n'
                  ' '.join(list(k for k,v in sorted(STATUS.items(),
                                                    key= lambda x: x[1]))))
        Queue = Queue.SelAttrVal(attr='status_key',value=status)
        
    if opts.user is not None:
        user = set(opts.user.split(','))
        Queue = Queue.SelAttrVal(attr='user',value=user)
    
    if ok:
        for k,v in Queue.items():
            print('{0:08}  {1.priority:d} {1.status_key:5s}  {1.user:9s} '
                  '{1.description:15s} {1.hostname:s} '
                  '{1.runninghost}'.format(k, v))
    
    
    
main()