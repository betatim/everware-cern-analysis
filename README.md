CERN Analysis with everware
---------------------------

A basic container to use as inspiration for your
own analysis container. It comes with several tools
integrating it with the CERN infrastructure.


Using this
----------

The idea of this repository is to provide a basic
container for you to build on. The simplest way to
do this is to place a file named `Dockerfile` in the
top level of your repository with the following
contents:

```
FROM betatim/cern_analysis_everware:31102015
```

Another way is to use the contents of this repository
to build your own basic container. Keep in mind that
you do not want your actual analysis container doing
this much work. Compiling all of ROOT every time we
build your analysis container takes a lot of time.
Instead your analysis container should inherit from
a basic container and fine tune it.


CERN integration
----------------

This container has support for Python, git, ROOT 6.05,
kerberos, xrootd, jupyter notebooks, and CERNBox.
