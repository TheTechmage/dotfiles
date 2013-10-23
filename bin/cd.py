#!/usr/bin/python
import sys
import os

aliases = {
    'scribes': '~/.Scribes/files/dev/' + 'e/i/e/i/o',
    'sb': '~/build/sb/src/',
    'df': '~/.files/',
}


def traverse_path(path, debug=False, test=False):
    if debug and not test:
        print(path)
    if os.path.isdir(path):
        return path
    else:
        return traverse_path(os.path.abspath(os.path.join(path, '..')), debug)


def arguments():
    import argparse

    # .:. Parser .:.
    parser = argparse.ArgumentParser(prog='gotoo', usage='%(prog)s [-d] ALIAS',
                                     description="""\
            Print out the location of an alias and go up the directory tree
            if the path doesn\'t exist.""")

    # .:. Arguments .:.
    parser.add_argument('-d', '--debug', action='store_true', required=False,
                        help="Debug mode!")
    parser.add_argument('-t', '--test', action='store_true', required=False,
                        help="Testing mode! (Returns status code only)")
    parser.add_argument('alias', choices=aliases.keys(), type=str,
                        help="Your special alias ^.^")

    # .:. Return dem arrrrrrgs! .:.
    return parser.parse_args()

if __name__ == '__main__':
    args = arguments()
    if args.alias in aliases.keys():
        path = traverse_path(
            os.path.abspath(
                os.path.expanduser(
                    os.path.expandvars(aliases[args.alias])
                    )
                ),
            args.debug, args.test)
        if not args.test:
            sys.stdout.write(path)
    else:
        if not args.test:
            sys.stderr('Error: Invalid alias!')
        sys.exit(1)

# vim: set sw=4 ts=4 ai et :
