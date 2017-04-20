import os
import sys

os.system("echo 'Ваш пароль: {0}' | mail -s 'Password recovery' {1} -aFrom: vdl.game.ru@gmail.com".format(sys.argv[1], sys.argv[2]))