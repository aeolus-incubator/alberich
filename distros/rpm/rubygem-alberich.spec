# Generated from alberich-0.1.1.gem by gem2rpm -*- rpm-spec -*-
%global gem_name alberich
%global rubyabi 1.9.1

Summary: Model-integrated permissions infrastructure for Rails projects
Name: rubygem-%{gem_name}
Version: 0.1.1
Release: 1%{?dist}
Group: Development/Languages
License: MIT
URL: https://github.com/aeolus-incubator/alberich
Source0: http://rubygems.org/gems/%{gem_name}-%{version}.gem
Requires: ruby(abi) = %{rubyabi}
Requires: ruby(rubygems) 
Requires: ruby 
Requires: rubygem(rails) => 3.2.11
Requires: rubygem(rails) < 3.3
Requires: rubygem(haml) 
Requires: rubygem(haml-rails) 
Requires: rubygem(nokogiri) 
Requires: rubygem(jquery-rails) 
Requires: rubygem(rails_warden) 
BuildRequires: ruby(abi) = %{rubyabi}
BuildRequires: rubygems-devel 
BuildRequires: ruby 
BuildRequires: rubygem(nokogiri)
BuildRequires: rubygem(haml)
BuildRequires: rubygem(sqlite3)
BuildRequires: rubygem(rspec)
BuildRequires: rubygem(rspec-rails)
BuildRequires: rubygem(rails) => 3.2.8
BuildRequires: rubygem(rails) < 3.3
BuildRequires: rubygem(bundler)
BuildRequires: rubygem(minitest)
BuildRequires: rubygem(database_cleaner)
BuildRequires: rubygem(factory_girl_rails) => 4.1.0
BuildRequires: rubygem(rake)
BuildArch: noarch
Provides: rubygem(%{gem_name}) = %{version}

%description
Alberich is a model-integrated permissions engine that allows access control,
and list filtering based on user and group-assigned permissions both globally
and at an individual resouce level.


%package doc
Summary: Documentation for %{name}
Group: Documentation
Requires: %{name} = %{version}-%{release}
BuildArch: noarch

%description doc
Documentation for %{name}

%prep
%setup -q -c -T
mkdir -p .%{gem_dir}
gem install --local --install-dir .%{gem_dir} \
            --force %{SOURCE0}

%build

%install
mkdir -p %{buildroot}%{gem_dir}
cp -a .%{gem_dir}/* \
        %{buildroot}%{gem_dir}/



%files
%dir %{gem_instdir}
%{gem_libdir}
%exclude %{gem_cache}
%{gem_spec}
%doc %{gem_instdir}/MIT-LICENSE
%doc %{gem_instdir}/README.rdoc
%{gem_instdir}/Rakefile
%{gem_instdir}/spec
%{gem_instdir}/app
%{gem_instdir}/config
%{gem_instdir}/db
%{gem_instdir}/test
%{gem_instdir}/alberich.gemspec

%files doc
%doc %{gem_docdir}
%{gem_instdir}/Gemfile

%changelog
* Mon Feb 04 2013 Scott Seago - 0.1.1-1
- Initial package
