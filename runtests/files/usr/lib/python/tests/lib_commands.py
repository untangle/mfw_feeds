class LibCommands:
    initialized = False

    @staticmethod
    def initialize():
        LibCommands.initialzied = True

    @staticmethod
    def wget(uri=None, tries=2, timeout=2, log_file=None, output_file=None, cookies_save_file=None, cookies_load_file=None, header=None, user_agent=None, post_data=None, override_arguments=None, extra_arguments=None, ignore_certificate=True, user=None, password=None, quiet=True, all_parameters=False, content_on_error=False):
        """
        Build wget command

        wget is best for straight http (not https) testing

        Default arguments should be evident, but of particular note are:
        override_arguments  If you really want to ignore the standard arguments and options, use it.  For example, if you really wanted to use hsts.
        extra_arguments     Additional arguments not otherwise processed.
        """
        if uri is None:
            uri = f"http://{TEST_SERVER_HOST}/"

        arguments = []
        if override_arguments is not None:
            # Allow completely custom arguments
            arguments = override_arguments
        else:
            arguments.append("--no-hsts --no-cache")
            # We only process ipv4.
            arguments.append("--inet4-only")

            if quiet is True:
                arguments.append("--quiet")
            if tries is not None:
                arguments.append(f"--tries={tries}")
            if timeout is not None:
                arguments.append(f"--timeout={timeout}")

            if ignore_certificate is True and "https" in uri:
                arguments.append(f"--no-check-certificate")

            if all_parameters is True:
                arguments.append(f'"$@"')

        optional_arguments = []
        if log_file is not None:
            optional_arguments.append(f"--output-file={log_file}")
        if output_file is not None:
            optional_arguments.append(f"--output-document={output_file}")
        if cookies_save_file is not None:
            optional_arguments.append(f"--save-cookies={cookies_save_file}")
        if cookies_load_file is not None:
            optional_arguments.append(f"--load-cookies={cookies_load_file}")
        if header is not None:
            optional_arguments.append(f"--header='{header}'")
        if user_agent is not None:
            optional_arguments.append(f"--user-agent='{user_agent}'")
        if post_data is not None:
            optional_arguments.append(f"--post-data='{post_data}'")
        if content_on_error is not False:
            optional_arguments.append(f"--content-on-error")
        if user is not None:
            optional_arguments.append(f"--user='{user}'")
        if password is not None:
            optional_arguments.append(f"--password='{password}'")

        if extra_arguments is not None:
            optional_arguments.append(extra_arguments)

        return f"wget {' '.join(arguments)} {' '.join(optional_arguments)} '{uri}'"

if LibCommands.initialized is False:
    LibCommands.initialize()
