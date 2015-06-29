#!/usr/bin/python3
import argparse
import io
import subprocess

from flask import Flask, request
app = Flask(__name__)

DASH_MACS = """
00:bb:3a:04:d2:65
74:c2:46:dc:e3:7e
10:ae:60:fb:1f:dc
""".strip().split()
print("Macs: %r" % DASH_MACS)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--host', default='0.0.0.0')
    parser.add_argument('--port', type=int, default='8000')
    parser.add_argument('--debug', action='store_true')
    args = parser.parse_args()
    app.run(**vars(args))

def speak(message):
    with subprocess.Popen(['festival', '--tts'], stdin=subprocess.PIPE) as p:
        p.stdin.write(message.encode('utf-8'))

@app.route('/dash')
def dash():
    mode, mac, ip, host = map(request.args.get, "mode mac ip host".split())

    if mac in DASH_MACS:
        if mode in ['add', 'old']:
            subprocess.check_call(['mplayer', '/home/lumpy/python/attacca/theme.flac'])
    else:
        if host:
            if host.startswith('android'):
                subject = 'Android device'
            else:
                subject = '%s' % host
        elif mac in DASH_MACS:
            subject = 'Dash button'
        else:
            subject = 'random citizen'

        if mode == 'add':
            speak('hello %s' % subject)
        elif mode == 'del':
            speak('goodbye %s' % subject)

    return 'ok'

if __name__ == '__main__':
    main()
