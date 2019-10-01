#!/usr/bin/env python3

import argparse
import sys
import os
import json
import requests
import datetime
import time
import re

OPENWRT_BASE_URL = 'http://jenkins.untangle.int/job/MFW%20pipeline/job/openwrt-18.06/'
OPENWRT_LIST_QUERY = ('api/json?tree='
    'fullDisplayName,'
    'healthReport[description],'
    'lastSuccessfulBuild[number],'
    'builds['
        'displayName,'
        'result,'
        'building,'
        'number,'
        'timestamp,'
        'duration,'
        'artifacts[fileName]'
    ']')


# avoid exceptions traceback
sys.tracebacklimit = 0

# add some color
def c_red(str): return ("\x1b[91m{}\x1b[00m".format(str))
def c_green(str): return ("\033[92m{}\033[00m".format(str))
def c_yellow(str): return "\033[93m{}\033[00m".format(str)
def c_gray(str): return "\033[90m{}\033[00m".format(str)

def find_vdi_artifact(artifacts):
    # Find the x86-64 vdi artifact required for the VirtualBox
    files = [art for art in artifacts
        if re.search('sdwan-x86-64-combined_v(.*).vdi', art['fileName'])
    ]
    if files:
        return files[0]
    return None


def color_build_status(argument):
    # paints build status in different color based on its value
    switcher = {
        'SUCCESS': c_green('SUCCESS'),
        'FAILURE': c_red('FAILURE'),
        'ABORTED': c_red('ABORTED'),
        'PENDING': c_yellow('PENDING')
    }
    return switcher.get(argument)


def list(limit):
    # queries jenkins for the last <limit> number of builds
    print('Querying Jenkins for the last ' + str(limit) + ' OpenWrt builds ...\n')

    # applies a limit to the query
    range = '{0,' + str(limit) + '}'

    try:
        response = requests.get(OPENWRT_BASE_URL + OPENWRT_LIST_QUERY + range)
        data = json.loads(response.text)
    except requests.exceptions.RequestException:
        print(c_red('Unable to reach Jenkins. Is untangle VPN connected?') + '\n')
        sys.exit(1)

    os.system('clear')

    print(
        '' + c_green(data['fullDisplayName']) + '\n\n'
        '' + data['healthReport'][0]['description'] + '\n'
        'Last successful build: ' + str(data['lastSuccessfulBuild']['number']) + '\n\n'
        'no. ' + c_gray('|'),
        'status  ' + c_gray('|'),
        'timestamp      ' + c_gray('|'),
        'dur.    ' + c_gray('|'),
        'vdi file name'
    )
    print(c_gray('-----------------------------------------------------------'))

    for build in data["builds"]:
        time = datetime.datetime.fromtimestamp(build['timestamp']/1000).strftime('%b %d %I:%M%p')
        duration = str(datetime.timedelta(seconds=int(build['duration']/1000)))
        artifact = find_vdi_artifact(build['artifacts'])
        result = "PENDING" if build['result'] is None else build['result']

        print(
            build['number'], c_gray('|'),
            color_build_status(result), c_gray('|'),
            time, c_gray('|'),
            duration, c_gray('|'),
            c_green(None if artifact is None else artifact['fileName'])
        )

    print(
        c_gray('-----------------------------------------------------------\n\n') +
        'To list a different number of builds, type: ' + c_green('./mfw.py -l <limit_no>') + '\n'
        'To download specific build files, type: ' + c_green('./mfw.py -d <build_no>') + '\n'
        'To create VirtualBox instance, type: ' + c_green('./mfw.py -i <build_no>') + '\n'
    )


def download(build_no, vbox=False):
    # download a file frrom a specific OpenWrt build
    # or downlaods the vdi file for virtual box if vbox=True
    try:
        print('Getting build ' + str(build_no) + ' details and artifacts ... ')
        response = requests.get(OPENWRT_BASE_URL + str(build_no) + '/api/json')
        if response.status_code != 200:
            print('No such build with number ' + str(build_no))
            sys.exit(1)
        data = json.loads(response.text)

    except requests.exceptions.RequestException:
        print(c_red('Unable to reach Jenkins. Is untangle VPN connected?') + '\n')
        sys.exit(1)

    # with open("details.json") as json_file:
    #     data = json.load(json_file)

    # create a tree of artifacts
    categories = {
        'x86-64': [],
        'wrt1900acs': [],
        'wrt3200acm': [],
        'wrt32x': [],
        'espressobin': [],
        'omnia': [],
        'others': [] # todo: populate it
    }

    for artifact in data['artifacts']:
        for category in categories:
            if category in artifact['fileName']:
                categories[category].append(artifact)

    # displays the build info
    def info():
        os.system('clear')
        print(
            c_green(data['fullDisplayName']) + '\n' +
            c_gray('------------------------') + '\n' +
            c_green('Build number:  ') + str(data['number']) + '\n' +
            c_green('Is building:   ') + str(data['building']) + '\n' +
            c_green('Build result:  ') + str(color_build_status(data['result'])) + '\n' +
            c_green('Timestamp:     ') + str(datetime.datetime.fromtimestamp(data['timestamp']/1000).strftime('%b %d %I:%M%p')) + '\n' +
            c_green('Duration:      ') + str(datetime.timedelta(seconds=int(data['duration']/1000))) + '\n' +
            c_green('Est. duration: ') + str(datetime.timedelta(seconds=int(data['estimatedDuration']/1000))) + '\n' +
            c_gray('------------------------') + '\n'
        )

    def download(rPath):
        file_url = OPENWRT_BASE_URL + str(build_no) + '/artifact/' + rPath
        file_name = 'sdwan-' + str(build_no) + '.vdi'

        if vbox:
            print('Downloading as "' + file_name + '" to ' + os.getcwd() + ' ...\n')
        else:
            print('Downloading to ' + os.getcwd() + ' ...\n')

        try:
            if vbox:
                os.system('wget -q --show-progress -O ' + file_name + ' ' + file_url)
            else:
                os.system('wget -q --show-progress ' + file_url)
        except:
            print(c_red('Unable to download file') + '\n')
            sys.exit(1)

    if data['result'] != 'SUCCESS':
        print('Build ' + str(build_no) + ' was not successful. No downloads available')
        sys.exit(1)

    def categories_menu():
        # show appliances categories menu
        info()
        menu = {}
        for idx, category in enumerate(categories, start=1):
            menu[str(idx)] = category

        for key in menu.keys():
            print(key + ': ' + menu[key])

        print('\nType "q" to quit')

        sel = input('\nSelect category: ')
        if sel is 'q':
            sys.exit(1)
        if sel in menu.keys():
            artifacts_menu(categories[menu[sel]])
        else:
            categories_menu()

    def artifacts_menu(artifacts):
        # show artifacts
        info()
        menu = {}
        for idx, artifact in enumerate(artifacts, start=1):
            menu[str(idx)] = artifact

        for key in menu.keys():
            print(key + ': ' + menu[key]['fileName'])

        print('\nType "b" to go back or "q" to quit')

        sel = input('\nSelect file: ')
        if sel is 'q':
            sys.exit(1)
        if sel is 'b':
            categories_menu()
        if sel in menu.keys():
            download(menu[sel]['relativePath'])

    if vbox:
        vdi_artifact = find_vdi_artifact(data['artifacts'])
        if vdi_artifact:
            info()
            download(vdi_artifact['relativePath'])
            return
        else:
            print('Unable to download vdi')
            sys.exit(1)

    categories_menu()


def clean(build_no):
    box_name = 'sdwan-' + str(build_no)

    is_running = os.popen('vboxmanage list runningvms | grep "' + box_name + '"').read()
    is_installed = os.popen('vboxmanage list vms | grep "' + box_name + '"').read()

    if is_running:
        message = 'VBox ' + box_name + ' is already installed and running.\nShut it down and reinstall it anyway?'
        action = input("%s (y/N) " % message).lower() == 'y'
        if (action):
            print('Shutting down ' + box_name)
            os.system('vboxmanage controlvm ' + box_name + ' poweroff')
            time.sleep(3)
            print('Unregistering ' + box_name)
            os.system('vboxmanage unregistervm --delete ' + box_name)
            return
        else:
            sys.exit(1)

    if is_installed:
        message = box_name + ' is already installed. Reinstall anyway?'
        action = input("%s (y/N) " % message).lower() == 'y'
        if (action):
            os.system('vboxmanage unregistervm --delete ' + box_name)
            return
        else:
            sys.exit(1)


def create_vbox(build_no):
    box_name = 'sdwan-' + str(build_no)
    box_file = box_name + '.vdi'
    bridget_intf = None

    clean(build_no)
    download(build_no, True)

    # create interfaces menu for box bridged adapter
    interfaces = os.popen('ip -o link | grep ether | awk \'{print $2}\' | sed -r \'s/://\'').read().rstrip()

    menu = {}
    for idx, intf in enumerate(interfaces.split('\n'), start=1):
        menu[str(idx)] = intf

    print('Select interface for the "' + box_name + '" box bridged adapter:')
    for key in menu.keys():
        print(key + ': ' + menu[key])

    sel = input('\nChoose: ')
    if sel in menu.keys():
        bridget_intf = menu[sel]
    else:
        print('Warning! The Virtual Box bridged adapter interface is missing')

    # create the sdwan box
    create_cmd = 'vboxmanage createvm \
        --name "' + box_name + '" \
        --ostype Linux_64 \
        --register'

    # modify sdwan box
    modify_cmd = 'vboxmanage modifyvm "' + box_name + '" \
        --description "Untangle SD-WAN build ' + box_name + '" \
        --memory 1024 \
        --vram 16 \
        --audio none \
        --nic1 intnet \
        --nic2 bridged \
        --intnet1 "sdwan" \
        --bridgeadapter2 "' + bridget_intf + '"'

    # add storage controller
    storage_cmd1 = 'vboxmanage storagectl "' + box_name + '" \
        --name "IDE" \
        --add ide \
        --bootable on'

    # attach storage (the vdi file)
    storage_cmd2 = 'vboxmanage storageattach "' + box_name + '" \
        --storagectl "IDE" \
        --type hdd \
        --port 0 \
        --device 0 \
        --medium ' + box_file

    start_cmd = 'vboxmanage startvm "' + box_name + '" --type gui'

    os.system(create_cmd)
    os.system(modify_cmd)
    os.system(storage_cmd1)
    os.system(storage_cmd2)
    os.system(start_cmd)


# Arguments parser
parser = argparse.ArgumentParser(
    description='Untangle SD-WAN Router tools\n' +
        '- info and status about latest builds\n' +
        '- download artifacts\n' +
        '- create VirtualBox instances from x86-64 vdi\n',
    formatter_class=argparse.RawTextHelpFormatter)

command_group = parser.add_mutually_exclusive_group()
command_group.add_argument('-l',
    action="store",
    dest="limit",
    type=int,
    nargs="?",
    const=20,
    help='show info and latest 10 or specified by LIMIT builds'
)
command_group.add_argument('-i',
    action="store",
    dest="install_number",
    type=int,
    nargs="?",
    const=0,
    help='download specified by INSTALL_NUMBER (build number) and creates VBox with it'
)
command_group.add_argument('-d',
    action="store",
    dest="build_number",
    type=int,
    nargs="?",
    const=0,
    help='list and download available artifacts for a specific build number'
)

parser.add_argument('-v',
    action='version',
    version='%(prog)s 0.0.3'
)

args = parser.parse_args()
# print(args)

# no arguments passed to command
if (len(sys.argv) == 1):
    list(10)

if (args.limit):
    list(args.limit)

if (args.build_number):
    download(args.build_number)

if (args.install_number):
    create_vbox(args.install_number)
