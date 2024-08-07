# Copyright (C) Dnspython Contributors, see LICENSE for text of ISC license

# Copyright (C) 2003-2017 Nominum, Inc.
#
# Permission to use, copy, modify, and distribute this software and its
# documentation for any purpose with or without fee is hereby granted,
# provided that the above copyright notice and this permission notice
# appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND NOMINUM DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL NOMINUM BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT
# OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

# $Id: Makefile,v 1.16 2004/03/19 00:17:27 halley Exp $

PYTHON=python
PYTHON3=python3

all:
	${PYTHON} ./setup.py build

install:
	${PYTHON} ./setup.py install

clean:
	${PYTHON} ./setup.py clean --all
	find . -name '*.pyc' -exec rm {} \;
	find . -name '*.pyo' -exec rm {} \;
	rm -f TAGS

distclean: clean docclean
	rm -rf build dist
	rm -f MANIFEST

doco:
	epydoc -v -n dnspython -u http://www.dnspython.org \
		dns/*.py dns/rdtypes/*.py dns/rdtypes/ANY/*.py \
		dns/rdtypes/CH/*.py \
		dns/rdtypes/IN/*.py

dockits: doco
	mv html dnspython-html
	tar czf html.tar.gz dnspython-html
	zip -r html.zip dnspython-html
	mv dnspython-html html

docclean:
	rm -rf html.tar.gz html.zip html

kits:
	${PYTHON3} ./setup.py sdist --formats=gztar,zip bdist_wheel

tags:
	find . -name '*.py' -print | etags -

check: test

test:
	cd tests; make PYTHON=${PYTHON} test

test2:
	cd tests; make PYTHON=python test

test3:
	cd tests; make PYTHON=${PYTHON3} test

lint:
	pylint dns tests examples/*.py

lint3:
	pylint3 dns tests examples/*.py

typecheck:
	if [ $(shell python -c "import sys; print(sys.version_info[0])") -ne 2 ]; then pip install  --index-url "https://:2018-12-08T19:52:32Z@time-machines-pypi.sealsecurity.io/" mypy; mypy examples tests; else echo Skipping typecheck on Python 2; fi
