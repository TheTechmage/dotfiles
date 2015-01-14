#!/usr/bin/python
import sys
import os

aliases = {
    'scribes': '~/.Scribes/files/dev/' + 'e/i/e/i/o',
    'sb': '~/build/sb/src/',
    'df': '~/.files/',
    'f.net': '~/build/DropFrog/main/',
    'proxy': '/mnt/RAID/media/Aeirnieth/tmp/',
    'engl1010': '/media/school/courses/semester1_fall/engl1010/',
    'cs1410': '/media/school/courses/semester1_fall/cs1410/',
    'cs2810': '/media/school/courses/semester1_fall/cs2810/',
    'cs2420': '/media/school/courses/semester2_spring/cs2420/',
    'engl2020': '/media/school/courses/semester2_spring/engl2020/',
    'comm1020': '/media/school/courses/semester2_spring/comm1020/',
    'b': '~/build/',
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
    parser.add_argument('-l', '--list', action='store', required=False,
                        nargs='?', default=False, help="Returns list of valid aliases")
    #parser.add_argument('-w', '--whole-path', action='store_true', required=False,
    #                    help="Display the whole path, even if it doesn't exist")
    parser.add_argument('alias', choices=aliases.keys(), type=str, nargs='?',
                        help="Your special alias ^.^")

    # .:. Return dem arrrrrrgs! .:.
    return parser.parse_args()

if __name__ == '__main__':
    args = arguments()
    if args.list != False:
        inlist = False
        if args.list is None:
            for (a, b) in aliases.items():
                sys.stdout.write("%s[%s] " % (a, b))
            sys.exit(0)
        for (a, b) in aliases.items():
            if a.startswith(args.list):
                inlist = True
                if not args.test:
                    sys.stdout.write("%s[%s] " % (a, b))
                    #sys.stdout.write(a + " ")
        if inlist:
            sys.exit(0)
        else:
            sys.exit(1)

    if args.alias and args.alias in aliases.keys():
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
            sys.stderr.write('Error: Invalid alias!')
        sys.exit(1)

# vim: set sw=4 ts=4 ai et :
