#
# spec file for package libzypp-bindings
#
# Copyright (c) 2007 SUSE LINUX Products GmbH, Nuernberg, Germany.
# This file and all modifications and additions to the pristine
# package are under the same license as the package itself.
#
# Please submit bugfixes or comments via http://bugs.opensuse.org/
#

# nodebuginfo

Name:           @PACKAGE@
Version:        @VERSION@
Release:        0
License:        GPL v2 or later
Summary:        Bindings for libzypp
Group:          Development/Sources
BuildRoot:      %{_tmppath}/%{name}-%{version}-build
BuildRequires:  cmake gcc-c++ python-devel ruby-devel
BuildRequires:  swig >= 1.3.40
BuildRequires:  libzypp-devel >= 5.8.0
Source:         %{name}-%{version}.tar.bz2

%description
This package provides bindings for libzypp, the library for package management.

%prep
%setup -q

%build
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=%{prefix} \
      -DPYTHON_SITEDIR=%{py_sitedir} \
      -DLIB=%{_lib} \
      -DCMAKE_VERBOSE_MAKEFILE=TRUE \
      -DCMAKE_C_FLAGS_RELEASE:STRING="%{optflags}" \
      -DCMAKE_CXX_FLAGS_RELEASE:STRING="%{optflags}" \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_SKIP_RPATH=1 \
      ..
# the swig compile jobs take a lot of memory, so don't use %jobs here
make -j1

%check
cd build
make test

%install
cd build
make install DESTDIR=$RPM_BUILD_ROOT

%clean
%{__rm} -rf %{buildroot}

%package -n ruby-zypp
Summary:        Ruby bindings for libzypp
Group:          Development/Languages/Ruby

%description -n ruby-zypp
-

%files -n ruby-zypp
%defattr(-,root,root,-)
%if 0%{?suse_version}
%{_libdir}/ruby/vendor_ruby/%{rb_ver}/%{rb_arch}/zypp.so
%endif
%if 0%{?mandriva_version}
%{ruby_sitearchdir}/zypp.so
%endif

%package -n python-zypp
Summary:        Python bindings for libzypp
Group:          Development/Languages/Python
%description -n python-zypp
-

%files -n python-zypp
%defattr(-,root,root,-)
%{py_sitedir}/_zypp.so
%{py_sitedir}/zypp.py

%package -n perl-zypp
Requires:       perl = %{perl_version}
Summary:        Perl bindings for libzypp
Group:          Development/Languages/Perl

%description -n perl-zypp
-

%files -n perl-zypp
%defattr(-,root,root,-)
%{perl_vendorlib}/zypp.pm
%{perl_vendorarch}/zypp.so

%changelog
