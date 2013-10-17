#!/usr/bin/python
import sys
import os

aliases = {
    'scribes': '~/.Scribes/files/dev/' + 'e/i/e/i/o',
}


def traverse_path(path, debug=False):
    if debug:
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
            args.debug)
        sys.stdout.write(path)
    else:
        sys.stderr('Error: Invalid alias!')
        sys.exit(1)

# vim: set sw=4 ts=4 ai et :
