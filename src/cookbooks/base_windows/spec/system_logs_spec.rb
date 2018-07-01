# frozen_string_literal: true

require 'spec_helper'

describe 'base_windows::system_logs' do
  consul_logs_path = 'c:/logs/consul'
  consul_template_logs_path = 'c:/logs/consul-template'
  firewall_logs_path = 'c:/logs/firewall'
  telegraf_logs_path = 'c:/logs/telegraf'
  unbound_logs_path = 'c:/logs/unbound'

  context 'create the consul-template files for telegraf' do
    let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

    # rubocop:disable Style/FormatStringToken
    telegraf_logs_config_content = <<~CONF
      # Telegraf Configuration

      ###############################################################################
      #                            INPUT PLUGINS                                    #
      ###############################################################################

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{consul_logs_path}/consul-service.out.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{DATESTAMP:timestamp} \\\\[%{LOGLEVEL:logLevel}\\\\] %{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "consul_output_log"

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{consul_logs_path}/consul-service.err.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "consul_error_log"

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{consul_template_logs_path}/consul-template.err.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{DATESTAMP:timestamp} \\\\[%{LOGLEVEL:logLevel}\\\\] %{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "consul_template_log"

          ## Full path(s) to custom pattern files.
          custom_pattern_files = []

          ## Custom patterns can also be defined here. Put one pattern per line.
          custom_patterns = '''
          '''

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{telegraf_logs_path}/telegraf.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{TIMESTAMP_ISO8601:timestamp} %{WORD:logLevel}\\\\! %{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "telegraf_log"

          ## Full path(s) to custom pattern files.
          custom_pattern_files = []

          ## Custom patterns can also be defined here. Put one pattern per line.
          custom_patterns = '''
          '''

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{unbound_logs_path}/unbound.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{CATALINA_DATESTAMP:timestamp} %{PROG:application}%{SYSLOG_PID:pid} %{LOGLEVEL:loglevel}: %{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "unbound_log"

          ## Full path(s) to custom pattern files.
          custom_pattern_files = []

          ## Custom patterns can also be defined here. Put one pattern per line.
          custom_patterns = '''
            CATALINA_DATESTAMP %{DATE_EU} %{TIME} (?:AM|PM)
            SYSLOG_PID (?:\\\\[.*\\\\])?
          '''

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{firewall_logs_path}/domain.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{DATESTAMP:timestamp} %{WORD:action} %{WORD:protocol} %{IP:sourceip} %{IP:destinationip} %{POSINT:sourceport} %{POSINT:destinationport} %{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "firewall_domain_log"

          ## Full path(s) to custom pattern files.
          custom_pattern_files = []

          ## Custom patterns can also be defined here. Put one pattern per line.
          custom_patterns = '''
          '''

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{firewall_logs_path}/private.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{DATESTAMP:timestamp} %{WORD:action} %{WORD:protocol} %{IP:sourceip} %{IP:destinationip} %{POSINT:sourceport} %{POSINT:destinationport} %{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "firewall_private_log"

          ## Full path(s) to custom pattern files.
          custom_pattern_files = []

          ## Custom patterns can also be defined here. Put one pattern per line.
          custom_patterns = '''
          '''

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      [[inputs.logparser]]
        [inputs.logparser.tags]
        rabbitmq_exchange = "logs.file"

        ## Log files to parse.
        ## These accept standard unix glob matching rules, but with the addition of
        ## ** as a "super asterisk". ie:
        ##   /var/log/**.log     -> recursively find all .log files in /var/log
        ##   /var/log/*/*.log    -> find all .log files with a parent dir in /var/log
        ##   /var/log/apache.log -> only tail the apache log file
        files = [
          "#{firewall_logs_path}/public.log"
        ]

        ## Read files that currently exist from the beginning. Files that are created
        ## while telegraf is running (and that match the "files" globs) will always
        ## be read from the beginning.
        from_beginning = false

        ## Method used to watch for file updates.  Can be either "inotify" or "poll".
        # watch_method = "inotify"

        ## Parse logstash-style "grok" patterns:
        ##   Telegraf built-in parsing patterns: https://goo.gl/dkay10
        [inputs.logparser.grok]
          ## This is a list of patterns to check the given log file(s) for.
          ## Note that adding patterns here increases processing time. The most
          ## efficient configuration is to have one pattern per logparser.
          ## Other common built-in patterns are:
          ##   %{COMMON_LOG_FORMAT}   (plain apache & nginx access logs)
          ##   %{COMBINED_LOG_FORMAT} (access logs + referrer & agent)
          patterns = ["%{DATESTAMP:timestamp} %{WORD:action} %{WORD:protocol} %{IP:sourceip} %{IP:destinationip} %{POSINT:sourceport} %{POSINT:destinationport} %{GREEDYDATA:message}"]

          ## Name of the outputted measurement name.
          measurement = "firewall_public_log"

          ## Full path(s) to custom pattern files.
          custom_pattern_files = []

          ## Custom patterns can also be defined here. Put one pattern per line.
          custom_patterns = '''
          '''

          ## Timezone allows you to provide an override for timestamps that
          ## don't already include an offset
          ## e.g. 04/06/2016 12:41:45 data one two 5.43µs
          ##
          ## Default: "" which renders UTC
          ## Options are as follows:
          ##   1. Local             -- interpret based on machine localtime
          ##   2. "Canada/Eastern"  -- Unix TZ values like those found in https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
          ##   3. UTC               -- or blank/unspecified, will return timestamp in UTC
          timezone = "UTC"

      ###############################################################################
      #                            OUTPUT PLUGINS                                   #
      ###############################################################################

      {{ if keyExists "config/services/queue/protocols/amqp/host" }}
      # Configuration for rabbitmq server to send logs to
      # Publishes metrics to an AMQP broker
      [[outputs.amqp]]
        ## Brokers to publish to.  If multiple brokers are specified a random broker
        ## will be selected anytime a connection is established.  This can be
        ## helpful for load balancing when not using a dedicated load balancer.
        brokers = [
          "amqp://{{ keyOrDefault "config/services/queue/protocols/amqp/host" "unknown" }}.service.{{ keyOrDefault "config/services/consul/domain" "unknown" }}:{{ keyOrDefault "config/services/queue/protocols/amqp/port" "5672" }}/{{ keyOrDefault "config/services/queue/logs/file/vhost" "unknown" }}"
        ]

        ## Maximum messages to send over a connection. Once this is reached, the
        ## connection is closed and a new connection is made. This can be helpful for
        ## load balancing when not using a dedicated load balancer.
        # max_messages = 0

        ## Exchange to declare and publish to.
        exchange = "{{ keyOrDefault "config/services/queue/logs/file/exchange" "" }}"

        ## Exchange type; common types are "direct", "fanout", "topic", "header", "x-consistent-hash".
        # exchange_type = "topic"

        ## If true, exchange will be passively declared.
        exchange_declare_passive = true

        ## If true, exchange will be created as a durable exchange.
        # exchange_durable = true

        ## Additional exchange arguments.
        # exchange_arguments = { }
        # exchange_arguments = {"hash_propery" = "timestamp"}

        ## Authentication credentials for the PLAIN auth_method.
        {{ with secret "rabbitmq/creds/write.vhost.logs.file" }}
          {{ if .Data.password }}
        username = "{{ .Data.username }}"
        password = "{{ .Data.password }}"
          {{ end }}
        {{ end }}

        ## Auth method. PLAIN and EXTERNAL are supported
        ## Using EXTERNAL requires enabling the rabbitmq_auth_mechanism_ssl plugin as
        ## described here: https://www.rabbitmq.com/plugins.html
        auth_method = "PLAIN"

        ## Metric tag to use as a routing key.
        ##   ie, if this tag exists, its value will be used as the routing key
        # routing_tag = "host"

        ## Static routing key.  Used when no routing_tag is set or as a fallback
        ## when the tag specified in routing tag is not found.
        # routing_key = ""
        routing_key = "file"

        ## Delivery Mode controls if a published message is persistent.
        ##   One of "transient" or "persistent".
        # delivery_mode = "transient"

        ## Static headers added to each published message.
        # headers = { }
        # headers = {"database" = "telegraf", "retention_policy" = "default"}

        ## Connection timeout.  If not provided, will default to 5s.  0s means no
        ## timeout (not recommended).
        timeout = "5s"

        ## Optional TLS Config
        # tls_ca = "/etc/telegraf/ca.pem"
        # tls_cert = "/etc/telegraf/cert.pem"
        # tls_key = "/etc/telegraf/key.pem"
        ## Use TLS but skip chain & host verification
        # insecure_skip_verify = false

        ## If true use batch serialization format instead of line based delimiting.
        ## Only applies to data formats which are not line based such as JSON.
        ## Recommended to set to true.
        use_batch_format = true

        ## Data format to output.
        ## Each data format has its own unique set of configuration options, read
        ## more about them here:
        ## https://github.com/influxdata/telegraf/blob/master/docs/DATA_FORMATS_OUTPUT.md
        data_format = "json"

        [outputs.amqp.tagpass]
          rabbitmq_exchange = ["logs.file"]
      {{ else }}
      # Send logs to nowhere at all
      [[outputs.discard]]
        # no configuration
      {{ end }}
    CONF
    # rubocop:enable Style/FormatStringToken
    it 'creates telegraf logs template file in the consul-template template directory' do
      expect(chef_run).to create_file('c:/config/consul-template/templates/telegraf_logs.ctmpl')
        .with_content(telegraf_logs_config_content)
    end

    consul_template_telegraf_logs_content = <<~CONF
      # This block defines the configuration for a template. Unlike other blocks,
      # this block may be specified multiple times to configure multiple templates.
      # It is also possible to configure templates via the CLI directly.
      template {
        # This is the source file on disk to use as the input template. This is often
        # called the "Consul Template template". This option is required if not using
        # the `contents` option.
        source = "c:/config/consul-template/templates/telegraf_logs.ctmpl"

        # This is the destination path on disk where the source template will render.
        # If the parent directories do not exist, Consul Template will attempt to
        # create them, unless create_dest_dirs is false.
        destination = "c:/config/telegraf/system_logs.conf"

        # This options tells Consul Template to create the parent directories of the
        # destination path if they do not exist. The default value is true.
        create_dest_dirs = false

        # This is the optional command to run when the template is rendered. The
        # command will only run if the resulting template changes. The command must
        # return within 30s (configurable), and it must have a successful exit code.
        # Consul Template is not a replacement for a process monitor or init system.
        command = "powershell.exe -noprofile -nologo -noninteractive -command \\"Restart-Service telegraf\\" "

        # This is the maximum amount of time to wait for the optional command to
        # return. Default is 30s.
        command_timeout = "15s"

        # Exit with an error when accessing a struct or map field/key that does not
        # exist. The default behavior will print "<no value>" when accessing a field
        # that does not exist. It is highly recommended you set this to "true" when
        # retrieving secrets from Vault.
        error_on_missing_key = false

        # This is the permission to render the file. If this option is left
        # unspecified, Consul Template will attempt to match the permissions of the
        # file that already exists at the destination path. If no file exists at that
        # path, the permissions are 0644.
        perms = 0755

        # This option backs up the previously rendered template at the destination
        # path before writing a new one. It keeps exactly one backup. This option is
        # useful for preventing accidental changes to the data without having a
        # rollback strategy.
        backup = true

        # These are the delimiters to use in the template. The default is "{{" and
        # "}}", but for some templates, it may be easier to use a different delimiter
        # that does not conflict with the output file itself.
        left_delimiter  = "{{"
        right_delimiter = "}}"

        # This is the `minimum(:maximum)` to wait before rendering a new template to
        # disk and triggering a command, separated by a colon (`:`). If the optional
        # maximum value is omitted, it is assumed to be 4x the required minimum value.
        # This is a numeric time with a unit suffix ("5s"). There is no default value.
        # The wait value for a template takes precedence over any globally-configured
        # wait.
        wait {
          min = "2s"
          max = "10s"
        }
      }
    CONF
    it 'creates telegraf_logs.hcl in the consul-template template directory' do
      expect(chef_run).to create_file('c:/config/consul-template/config/telegraf_logs.hcl')
        .with_content(consul_template_telegraf_logs_content)
    end
  end
end
