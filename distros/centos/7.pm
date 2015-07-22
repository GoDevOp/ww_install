package redhat;

$prerequisites =
{
  common => {
    mkdir => 'coreutils',
    mv => 'coreutils',
    gcc => 'gcc',
    make => 'make',
    patch => 'patch',
    system_config => 'system-config-services',
    tar => 'tar',
    gzip => 'gzip',
    unzip => 'coreutils',
    dvipng => 'dvipng',
    netpbm => 'netpbm-progs',  #provides giftopnm, ppmtopgm, pnmtops, pnmtopng, 
                        #and pgntopnm
    git => 'git',
    svn => 'subversion',

    apache2 => 'httpd',
    mysql => 'mysql',
    #mysql_server => 'mysql-server',
    #ssh_server => 'openssh-server',

    preview_latex => 'tex-preview',
    texlive => 'texlive-latex', 
    'Apache2::Request' => 'perl-libapreq2',#perl-libapreq2, mod_perl?
    'Apache2::Cookie' => 'perl-libapreq2',
    'Apache2::ServerRec' => 'mod_perl',
    'Apache2::ServerUtil' => 'mod_perl',
    'Benchmark' => 'perl',
    'Carp' => 'perl',
    'CGI' => 'perl-CGI',
    'CPAN' => 'perl-CPAN',
    'Data::Dumper' => 'perl',
    'Data::UUID' => 'uuid-perl',
    'Date::Format' => 'perl-TimeDate',
    'Date::Parse' => 'perl-TimeDate',
    'DateTime' => 'perl-DateTime',
    'DBD::mysql' => 'perl-DBD-mysql',
    'DBI' => 'perl-DBI',
    'Digest::MD5' => 'perl',
    'Email::Address' => 'perl-Email-Address',
    'Errno' => 'perl',
    'Exception::Class' => 'perl-Exception-Class',
    'File::Copy' => 'perl',
    'File::Find' => 'perl',
    'File::Find::Rule' => 'perl-File-Find-Rule',
    'File::Path' => 'perl',
    'File::Spec' => 'perl',
    'File::stat' => 'perl',
    'File::Temp' => 'perl',
    'GD' => 'perl-GD perl-GDGraph',
    'Getopt::Long' => 'perl',
    'Getopt::Std' => 'perl',
    'HTML::Entities' => 'perl-HTML-parser',
    'HTML::Scrubber' => 'perl-HTML-Scrubber',
    'HTML::Tagset' => 'perl-HTML-Tagset',
    'HTML::Template' => 'CPAN',
    'IO::File' => 'perl',
    'IPC::Cmd' => 'perl-IPC-Cmd',
    'Iterator' => 'CPAN',
    'Iterator::Util' => 'CPAN',
    'JSON' => 'perl-JSON',
    'Locale::Maketext::Lexicon' => 'perl-Locale-Maketext-Lexicon',
    'Locale::Maketext::Simple' => 'perl-Locale-Maketext-Simple',
    'Mail::Sender' => 'perl-Mail-Sender',
    'MIME::Base64' => 'perl',
    'Net::IP' => 'perl-Net-IP',
    'Net::LDAPS' => 'perl-LDAP',
    'Net::OAuth' => 'perl-Net-OAuth',
    'Net::SMTP' => 'perl',
    'Opcode' => 'perl',
    'PadWalker' => 'perl-PadWalker',
    'PHP::Serialization' => 'CPAN',
    'Pod::Usage' => 'perl',
    'Pod::WSDL' => 'CPAN',
    'Safe' => 'perl',
    'Scalar::Util' => 'perl',
    'SOAP::Lite' => 'perl-SOAP-Lite',
    'Socket' => 'perl',
    'SQL::Abstract' => 'perl-SQL-Abstract',
    'String::ShellQuote' => 'perl-String-ShellQuote',
    'Term::UI' => 'perl-Term-UI',
    'Text::CSV' => 'perl-Text-CSV',
    'Text::Wrap' => 'perl',
    'Tie::IxHash' => 'perl-Tie-IxHash',
    'Time::HiRes' => 'perl-Time-HiRes',
    'Time::Zone' => 'perl-TimeDate',
    'URI::Escape' => 'perl',
    'UUID::Tiny' => 'CPAN',
    'XML::Parser' => 'perl-XML-Parser',
    'XML::Parser::EasyTree' => 'CPAN',
    'XML::Writer' => 'perl-XML-Writer',
    'XMLRPC::Lite' => 'perl-SOAP-Lite',
  }
};

1;
sub add_epel {
  my $arch = `rpm -q --queryformat "%{ARCH}" \$(rpm -q --whatprovides /etc/redhat-release)`;
  #or: ARCH=$(uname -m)

  my $ver = `rpm -q --queryformat "%{VERSION}" \$(rpm -q --whatprovides /etc/redhat-release)`;
  my $majorver = substr($ver,0,1);
  #or: MAJORVER=$(cat /etc/redhat-release | awk -Frelease {'print $2'}  | awk {'print $1'} | awk -F. {'print $1'})
  open(my $fh,'>','/etc/yum.repos.d/epel-bootstrap.repo') 
    or die "Couldn't open /etc/yum.repos.d/epel-bootstrap.repo for writing: $!";
  print $fh <<EOM;
[epel]
name=Bootstrap EPEL
mirrorlist=http://mirrors.fedoraproject.org/mirrorlist?repo=epel-$majorver&arch=$arch
failovermethod=priority
enabled=0
gpgcheck=0
EOM
  close($fh);
  run_command(['yum', '--enablerepo=epel', '-y', 'install', 'epel-release']);
  #unlink('/etc/yum.repos.d/epel-bootstrap.repo');
}
sub yum_install {
  my @packages = @_;
  run_command(['yum','-y','update']);
  run_command(['yum','-y','install',@packages]);
}

