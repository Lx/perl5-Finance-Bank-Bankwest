use MooseX::Declare;
role t::lib::Util::ResponseFixtures {

    use Path::Class 'dir';
    use URI::file ();
    use WWW::Mechanize ();

    method uri_for(Str $basename) {
        my $html_dir = dir('t')->absolute->subdir('fixtures');
        $basename .= '.html' if $basename !~ /\./;
        return URI::file->new($html_dir->file($basename));
    }

    method response_for(Str $basename) {
        return WWW::Mechanize->new->get($self->uri_for($basename));
    }
}
